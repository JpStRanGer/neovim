return {
	"nvimtools/none-ls.nvim",
	keys = {
		{
			"<leader>gf",
			function()
				if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
					vim.lsp.buf.format({
						range = {
							["start"] = vim.api.nvim_buf_get_mark(0, "<"),
							["end"] = vim.api.nvim_buf_get_mark(0, ">"),
						},
					})
				else
					vim.lsp.buf.format()
				end
			end,
			mode = { "n", "v" },
			desc = "Format buffer/selection",
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
