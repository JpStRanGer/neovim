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
vim.wo.wrap = false
vim.wo.linebreak = true
vim.wo.list = false
vim.opt.textwidth = 0   -- aldri sett inn ekte linjeskift automatisk

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Folding
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Auto-create parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(ev)
		local dir = vim.fn.fnamemodify(ev.file, ":h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})
