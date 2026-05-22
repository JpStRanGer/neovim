return {
	"danymat/neogen",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		enabled = true,
		languages = {
			cpp = {
				template = {
					annotation_convention = "doxygen",
				},
			},
		},
	},
	keys = {
		{
			"<leader>d",
			function()
				require("neogen").generate()
			end,
			desc = "Generate doc comment",
		},
	},
}
