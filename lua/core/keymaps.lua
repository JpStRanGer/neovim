local map = vim.keymap.set

map("t", "<Esc>", [[<C-\\><C-n>]], { desc = "Terminal normal mode" })

-- C-h/j/k/l navigering håndteres av vim-tmux-navigator

map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Undo/redo helpers (in addition to built-in u and <C-r>)
map("n", "<leader>uu", "u", { desc = "Undo" })
map("n", "<leader>ur", "<C-r>", { desc = "Redo" })

-- Cmdline helper: paste system clipboard in / or : prompt
-- Native Vim register paste is still <C-r>{register} (example: <C-r>").
map("c", "<C-v>", "<C-r>+", { noremap = true })
