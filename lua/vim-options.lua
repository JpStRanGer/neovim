-- General settings
vim.cmd("syntax on")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true
vim.opt.updatetime = 1000   -- CursorHold etter 1s inaktivitet (default 4000); styrer disk-sjekk + illuminate/diagnostics-timing
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

-- Auto-reload: oppdag når en åpen fil er endret på disk (git pull, annen editor, build).
-- `autoread` (over) gir tillatelsen; `checktime` gjør selve sjekken. checktime kjøres
-- nesten aldri av seg selv i terminal, så vi trigger den på fokus + inaktivitet.
-- Krever `set -g focus-events on` i tmux for at FocusGained skal nå hit gjennom tmux.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		-- Ikke kjør i cmdline-modus eller i cmdline-window (':' / '/'), det avbryter input
		if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})

-- Si fra når en buffer faktisk ble lastet på nytt fra disk
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("Fil endret på disk – lastet inn på nytt", vim.log.levels.WARN)
	end,
})
