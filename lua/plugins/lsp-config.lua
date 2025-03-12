return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "lua_ls", "ts_ls", "pylsp", "bashls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- 2. configure each language server
			lspconfig.clangd.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.pylsp.setup({
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = { maxLineLength = 100 },
							autopep8 = { enabled = true },
							mypy = { enabled = true },
							rope = { enabled = true },
							black = { enabled = true },
							ruff = { enabled = true },
						},
					},
				},
			})
			lspconfig.bashls.setup({
				capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gd", function()
				require("telescope.builtin").lsp_definitions({
					jump_type = "never",
				})
			end, { desc = "Go to Definition (Telescope)" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
