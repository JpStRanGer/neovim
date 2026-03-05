return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			if cmp_ok then
				capabilities = cmp_lsp.default_capabilities(capabilities)
				capabilities.offsetEncoding = nil
			end

			vim.lsp.config("clangd", {
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--all-scopes-completion",
					"--header-insertion=iwyu",
					"--pch-storage=memory",
					"--query-driver=/usr/bin/clang++*,/usr/bin/clang-*,/usr/bin/g++*,/usr/bin/c++*",
					"--function-arg-placeholders=1",
				},
			})

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

			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "lua_ls", "pylsp", "bashls" },
				automatic_enable = true,
			})
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
