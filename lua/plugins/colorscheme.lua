return {
	{
		"rktjmp/lush.nvim",
		name = "lush",
		priority = 1000,
	},
	{
		"Mofiqul/vscode.nvim",
		name = "vscode",
		config = function()
			local color = require("vscode.colors").get_colors()
			require("vscode").setup({
				transparent = true,
				italic_comments = true,
				italic_inlayhints = true,
				underline_links = true,
				disable_nvimtree_bg = true,
				terminal_colors = true,
				color_overrides = {
					vscLineNumber = "#FFFFFF",
				},
				group_overrides = {
					Cursor = { fg = color.vscDarkBlue, bg = color.vscLightGreen, bold = true },
				},
			})

			vim.cmd.colorscheme("vscode")

			local function jinja_highlights()
				local hl = vim.api.nvim_set_hl
				hl(0, "@tag.delimiter.htmldjango", { fg = "#E5C07B", bold = true })
				hl(0, "@punctuation.delimiter.htmldjango", { fg = "#E5C07B", bold = true })
				hl(0, "@punctuation.bracket.htmldjango", { fg = "#E5C07B", bold = true })
				hl(0, "@punctuation.special.htmldjango", { fg = "#E5C07B", bold = true })
				hl(0, "@keyword.htmldjango", { fg = "#C586C0", italic = true })
				hl(0, "@keyword.control.htmldjango", { fg = "#C586C0", italic = true })
				hl(0, "@function.htmldjango", { fg = "#DCDCAA" })
				hl(0, "@function.call.htmldjango", { fg = "#DCDCAA" })
				hl(0, "@variable.htmldjango", { fg = "#9CDCFE" })
				hl(0, "@variable.builtin.htmldjango", { fg = "#9CDCFE", italic = true })
				hl(0, "@operator.htmldjango", { fg = "#D4D4D4" })
				hl(0, "@comment.htmldjango", { fg = "#6A9955", italic = true })
				hl(0, "@number.htmldjango", { fg = "#B5CEA8" })
				hl(0, "@boolean.htmldjango", { fg = "#569CD6", bold = true })
			end

			jinja_highlights()
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = jinja_highlights,
			})
		end,
	},
}
