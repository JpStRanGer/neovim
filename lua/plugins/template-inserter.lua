return {
	{
		"JpStRanGer/nvim-template-inserter",
		dependencies = { "nvim-telescope/telescope.nvim" },
		lazy = false,
		opts = {
			keymap = "<leader>tt",
		},
		keys = {
			{ "<leader>tt", desc = "Insert template" },
		},
	},
}
