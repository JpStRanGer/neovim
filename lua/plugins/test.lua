return {
	"myplugin",
	dir = "~/.config/nvim/lua/myplugin",
	config = function()
		require("myplugin").setup({
            -- greeting_message = "Hey there, Neovim user!",
            -- enable_autocmd = true,
        })
	end,
}
