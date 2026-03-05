# neovim
My Neovim configuration with a streamlined plugin setup and improved code folding.

## Features

- Lazy-loaded plugins managed with [lazy.nvim](https://github.com/folke/lazy.nvim)
- Modern folding using `nvim-ufo` and `statuscol.nvim`
  - Click a line number to fold or unfold the surrounding code
- Centralized keymap and filetype modules for easier maintenance
- Which-key grouping for all leader namespaces

## Keymap v2 plan

A concrete v2 keymap structure is documented in:

- `docs/KEYMAP_V2_PLAN.md`

## Formatter policy (standardized)

This config uses **none-ls as the single formatter owner**.

- Use `<leader>gf` to format (normal or visual selection).
- `none-ls` handles formatting tools (`clang_format`, `stylua`, `prettier`, `black`, `isort`).
- `pylsp` formatting plugins are disabled to avoid double-format behavior.

## Top 20 keymaps (daily use)

1. `<leader>?` → Show buffer-local keymaps (which-key)
2. `<leader>ff` → Find files
3. `<leader>fg` → Live grep
4. `<leader>fb` → Open buffers list
5. `<leader>fh` → Search help tags
6. `<leader>fs` → Search word under cursor
7. `<leader>fr` → Show LSP references
8. `<leader>fd` → Show diagnostics (float)
9. `<leader>ld` → Go to LSP definitions
10. `gd` → Go to LSP definitions
11. `gp` → Go to declaration
12. `K` → Hover docs
13. `<leader>ca` → Code actions
14. `<leader>sf` → Search functions/methods in current file
15. `<leader>rn` → Rename symbol
16. `<leader>gf` → Format via none-ls
17. `<leader>gb` → Git blame current line
18. `<leader>gB` → Toggle inline git blame
19. `<leader>tt` → Insert template
20. `<leader>U` → Toggle undotree

## Extra useful maps

- `<leader>cp` → Open color picker
- `<leader>oo` → Open Ollama prompt
- `<leader>oG` → Ollama code generation prompt
- `<leader>s?` → Surround cheatsheet popup
- `<C-n>` → Reveal current file in Neo-tree
- `<C-t>` → Toggle terminal
