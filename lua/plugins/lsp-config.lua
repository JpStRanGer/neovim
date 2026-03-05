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
			local cmp = require("cmp")
			cmp.setup({
				sources = cmp.config.sources({
					{ name = "nvim_lsp", keyword_length = 1 },
					{ name = "path" },
					{ name = "buffer", keyword_length = 3 },
					{ name = "luasnip" },
				}),
			})

			local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Fallback if "cmp-nvim-lsp" is not loaded corectly
			if cmp_ok then
				capabilities = cmp_lsp.default_capabilities(capabilities)
                capabilities.offsetEncoding = nil
			end

			-- Definer LSP-konfig FØR auto-enable:
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

			vim.lsp.config("pylsp", {
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = { maxLineLength = 100 },
							autopep8 = { enabled = false }, -- unngå dobbel formatter med black
							black = { enabled = true },
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

			-- Mason installerer + auto-ENABLER servere med vim.lsp.enable()
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "lua_ls", "pylsp", "bashls" },
				automatic_enable = true, -- default i v2, men vi er eksplisitte
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
			vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to Definition (Telescope)" })
			vim.keymap.set("n", "gp", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
			vim.keymap.set("v", "<leader>ca", function()
				vim.lsp.buf.code_action({
					context = { only = { "refactor.extract" } },
					range = {
						["start"] = vim.api.nvim_buf_get_mark(0, "<"),
						["end"] = vim.api.nvim_buf_get_mark(0, ">"),
					},
				})
			end, { desc = "Code Action (Visual) - Extract Function" })
			vim.keymap.set("n", "<leader>sf", function()
				builtin.lsp_document_symbols({ symbols = { "Function", "Method" } })
			end, { desc = "Search Functions" })
		end,
	},
}
