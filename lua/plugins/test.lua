if vim.env.NVIM_ENABLE_LOCAL_TEST ~= "1" then
	return {}
end

return {
	"myplugin",
	dir = "~/.config/nvim/lua/myplugin",
	config = function()
		require("myplugin").setup({})
	end,
}
