return {
	{
		"JpStRanGer/nvim-template-inserter",
		config = function()
			require("template_inserter").setup({
                keymap = "<leader>tt"
            })
		end,
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = false,
	},
}
