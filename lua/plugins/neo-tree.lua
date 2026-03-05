return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<C-n>", "<cmd>Neotree filesystem reveal left<CR>", desc = "Reveal file in Neo-tree" },
	},
	config = function()
		require("neo-tree").setup({
			window = {
				mappings = {
					["P"] = {
						"toggle_preview",
						config = {
							use_float = true,
							use_image_nvim = true,
							title = "Neo-tree Preview",
						},
					},
					["v"] = "open_vsplit",
					["s"] = "open_split",
				},
			},
		})
	end,
}
