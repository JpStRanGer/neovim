return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			if cmp_ok then
				capabilities = cmp_lsp.default_capabilities(capabilities)
				capabilities.offsetEncoding = nil
			end

			local clangd_cmd = {
				-- cosmos: routes to clangd-in-container; other projects fall through
				-- to the normal host clangd (see ~/.local/bin/cosmos-clangd-router)
				"cosmos-clangd-router",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--all-scopes-completion",
				"--header-insertion=iwyu",
				"--pch-storage=memory",
				"--query-driver=/usr/bin/clang++*,/usr/bin/clang-*,/usr/bin/g++*,/usr/bin/c++*,"
					.. "**/arm-none-eabi-g++*,"
					.. "**/xtensa-esp32-elf-g++*,"
					.. "**/xtensa-esp*-elf-g++*,"
					.. "**/riscv32-esp-elf-g++*",
				"--function-arg-placeholders=0",
			}

			-- The payment-terminal/examples are standalone C++23 teaching files.
			-- They must NOT be served by the container clangd (Rocky-9 GCC 11, no
			-- <format>) — only by a host clangd rooted at examples/. With one clangd
			-- config the worktree-rooted container client (its root is an ancestor)
			-- AND the examples-rooted one would both attach to the same buffer, and
			-- the container one re-introduces the false <format> errors. So we split
			-- into two configs whose root_dir functions are mutually exclusive by
			-- path: example files → clangd_examples (host), everything else → clangd.
			local examples_pat = "/payment%-terminal/examples/"

			vim.lsp.config("clangd", {
				capabilities = capabilities,
				cmd = clangd_cmd,
				-- Skip example files here (clangd_examples handles them). Returning
				-- without calling on_dir means this client does not attach.
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					if fname:match(examples_pat) then
						return
					end
					on_dir(vim.fs.root(fname, {
						".clangd",
						".clang-tidy",
						".clang-format",
						"compile_commands.json",
						"compile_flags.txt",
						"configure.ac",
						".git",
					}) or vim.fs.dirname(fname))
				end,
			})

			-- Dedicated HOST clangd for the standalone examples only. It must call
			-- the host clangd BINARY directly (not cosmos-clangd-router): nvim
			-- launches the server with cwd = the editor's cwd (usually the cosmos
			-- worktree), NOT root_dir, so the router would still pick the container.
			-- Host clangd (Mason, GCC 16) has <format>; examples/.clangd forces
			-- -std=c++23.
			local host_clangd = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/clangd")
			if vim.fn.executable(host_clangd) == 0 then
				host_clangd = "clangd"
			end
			local examples_cmd = vim.deepcopy(clangd_cmd)
			examples_cmd[1] = host_clangd

			vim.lsp.config("clangd_examples", {
				capabilities = capabilities,
				cmd = examples_cmd,
				filetypes = { "c", "cpp" },
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = fname:match("^(.*/payment%-terminal/examples)/")
					if root then
						on_dir(root)
					end
				end,
			})
			vim.lsp.enable("clangd_examples")

			-- Formatter policy: formatting is handled by none-ls (<leader>gf).
			-- Keep pylsp focused on diagnostics/intel to avoid double-format behavior.
			vim.lsp.config("pylsp", {
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = { maxLineLength = 100 },
							autopep8 = { enabled = false },
							black = { enabled = false },
							yapf = { enabled = false },
							ruff = { enabled = true },
							mypy = { enabled = true },
							rope = { enabled = true },
						},
					},
				},
			})

			vim.lsp.config("bashls", { capabilities = capabilities })
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			})

			-- cmake-language-server is installed outside Mason on this machine because
			-- its PyPI metadata caps Python at <3.14 and Fedora ships 3.14. Install:
			--   pip install --user --break-system-packages --ignore-requires-python \
			--     'pygls<2' cmake-language-server
			vim.lsp.config("cmake", { capabilities = capabilities })

			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "lua_ls", "pylsp", "bashls" },
				automatic_enable = true,
			})

			vim.lsp.enable("cmake")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "K", vim.lsp.buf.hover, desc = "LSP Hover" },
			{ "gd", function() require("telescope.builtin").lsp_definitions() end, desc = "LSP Definitions" },
			{ "gp", vim.lsp.buf.declaration, desc = "LSP Declaration" },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
			{
				"<leader>ca",
				function()
					vim.lsp.buf.code_action({
						context = { only = { "refactor.extract" } },
						range = {
							["start"] = vim.api.nvim_buf_get_mark(0, "<"),
							["end"] = vim.api.nvim_buf_get_mark(0, ">"),
						},
					})
				end,
				mode = "v",
				desc = "Extract function/action",
			},
			{
				"<leader>sf",
				function()
					require("telescope.builtin").lsp_document_symbols({ symbols = { "Function", "Method" } })
				end,
				desc = "Search functions/methods",
			},
		},
	},
}
