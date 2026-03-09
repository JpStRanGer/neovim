-- General settings
vim.cmd("syntax on")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- UI
vim.opt.mouse = "a"
vim.opt.winblend = 20
vim.opt.pumblend = 20
vim.opt.guifont = "Hack Nerd Font:h12"

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.list = false

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Folding
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
