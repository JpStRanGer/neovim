-- Basic settings
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("syntax on")
vim.cmd("set clipboard=unnamed,unnamedplus")

-- vim.o.clipboard = "unnamedplus"
-- Enable mouse (helps with selection in many terminals)
vim.cmd("set mouse=a")

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=4")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.winblend = 20
vim.o.pumblend = 20

-- Key bindings
-------------------------
--ToggleTerm
vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true }) -- Exit terminal mode with Esc

--TELESCOPE
-- local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
-- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- vim.keymap.set("n", "<leader>gr", :OpenReferencesInUiSelect)

vim.opt.guifont = "Hack Nerd Font:h12"
