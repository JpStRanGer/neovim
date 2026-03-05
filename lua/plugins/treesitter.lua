return {
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				multiwindow = false,
				max_lines = 0,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = "─",
				zindex = 20,
				on_attach = nil,
			})
			vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#3c3836", bold = true })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"cmake",
					"cpp",
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"elixir",
					"heex",
					"javascript",
					"html",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = { ["]c"] = "@case.label" },
						goto_previous_start = { ["[c"] = "@case.label" },
					},
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["as"] = "@switch.outer",
						},
					},
				},
			})
		end,
	},
}
