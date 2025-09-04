return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {},
		config = function()
			local cmp = require("cmp")
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- ENTER = velg forslag
					["<C-e>"] = cmp.mapping.abort(),
				}),
				sources = {
					{ name = "nvim_lsp" }, -- ← LSP-forslag
					{ name = "buffer" }, --eneste kilde: teksten i bufferen
				},
				snippet = {},
                formatting = {
                    format = function (entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            buffer = "[BUF]",
                            path = "[PATH]",
                        })[entry.source.name]
                        return vim_item
                    end
                }
			})
		end,
	},
}
