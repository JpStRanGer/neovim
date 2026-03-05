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
		end,
	},
}
