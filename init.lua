-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({git
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Install and configure plugins
require("vim-options")
require("lazy").setup("plugins")

