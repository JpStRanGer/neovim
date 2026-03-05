return {
	"nvimtools/none-ls.nvim",
	keys = {
		{
			"<leader>gf",
			function()
				local format_opts = {
					filter = function(client)
						return client.name == "null-ls"
					end,
				}

				if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
					format_opts.range = {
						["start"] = vim.api.nvim_buf_get_mark(0, "<"),
						["end"] = vim.api.nvim_buf_get_mark(0, ">"),
					}
				end

				vim.lsp.buf.format(format_opts)
			end,
			mode = { "n", "v" },
			desc = "Format via none-ls",
		},
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
			},
		})
	end,
}
