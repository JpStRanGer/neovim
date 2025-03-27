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
	{
		"metalelf0/jellybeans-nvim",
		name = "jellybean",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("jellybeans-nvim")
		end,
	},
}
