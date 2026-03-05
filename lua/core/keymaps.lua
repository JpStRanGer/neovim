local map = vim.keymap.set

map("n", "<C-t>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
map("t", "<Esc>", [[<C-\\><C-n>]], { desc = "Terminal normal mode" })

map("n", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Window up" })
map("n", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Window down" })
map("n", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Window left" })
map("n", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Window right" })

map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Undo/redo helpers (in addition to built-in u and <C-r>)
map("n", "<leader>uu", "u", { desc = "Undo" })
map("n", "<leader>ur", "<C-r>", { desc = "Redo" })

-- Cmdline helper: paste system clipboard in / or : prompt
-- Native Vim register paste is still <C-r>{register} (example: <C-r>").
map("c", "<C-v>", "<C-r>+", { noremap = true })
