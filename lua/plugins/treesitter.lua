return {
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = "─",
			})
			vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#3c3836", bold = true })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
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
					"htmldjango",
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
