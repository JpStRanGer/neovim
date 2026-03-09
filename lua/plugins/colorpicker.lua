return {
	"ziontee113/color-picker.nvim",
	keys = {
		{ "<leader>cp", "<cmd>PickColor<cr>", desc = "Pick color" },
	},
	config = function()
		require("color-picker").setup({
			icons = { "ﱢ", "" },
			border = "rounded",
			keymap = {
				U = "<Plug>ColorPickerSlider5Decrease",
				O = "<Plug>ColorPickerSlider5Increase",
			},
			background_highlight_group = "Normal",
			border_highlight_group = "FloatBorder",
			text_highlight_group = "Normal",
		})
	end,
}
