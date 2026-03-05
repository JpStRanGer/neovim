-- return {
-- 	"catppuccin/nvim",
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }
return {
	{
		"rktjmp/lush.nvim",
		name = "lush",
		priority = 1000,
	},
	-- {
	-- 	"metalelf0/jellybeans-nvim",
	-- 	name = "jellybean",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("jellybeans-nvim")
	-- 	end,
	-- },
	{
		"Mofiqul/vscode.nvim",
		name = "vscode",
		config = function()
			local color = require("vscode.colors").get_colors()
			require("vscode").setup({
				-- Alternatively set style in setup
				-- style = 'light'

				-- Enable transparent background
				transparent = true,

				-- Enable italic comment
				italic_comments = true,

				-- Enable italic inlay type hints
				italic_inlayhints = true,

				-- Underline `@markup.link.*` variants
				underline_links = true,

				-- Disable nvim-tree background color
				disable_nvimtree_bg = true,

				-- Apply theme colors to terminal
				terminal_colors = true,

				-- Override colors (see ./lua/vscode/colors.lua)
				color_overrides = {
					vscLineNumber = "#FFFFFF",
				},

				-- Override highlight groups (see ./lua/vscode/theme.lua)
				group_overrides = {
					-- this supports the same val table as vim.api.nvim_set_hl
					-- use colors from this colorscheme by requiring vscode.colors!
					Cursor = { fg = color.vscDarkBlue, bg = color.vscLightGreen, bold = true },
				},
			})
			-- require('vscode').load()

			-- load the theme without affecting devicon colors.
			vim.cmd.colorscheme("vscode")

            -- If you are using lualine, you can also enable the provided theme:
			require("lualine").setup({
				options = {
					-- ...
					theme = "vscode",
					-- ...
				},
			})
		end,
	},
}
