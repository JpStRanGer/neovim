-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		--"git@github.com:folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Install and configure plugins
require("vim-options")

-- Viktig: fortell Lazy å bruke SSH-URLer til GitHub
require("lazy").setup("plugins")
-- require("lazy").setup("plugins", {
--     git = {
--         url_format = "git@github.com:%s.git",
--     },
-- })
