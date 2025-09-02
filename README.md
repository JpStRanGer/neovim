# neovim
My Neovim configuration with a streamlined plugin setup and improved code folding.

### Features

- Lazy-loaded plugins managed with [lazy.nvim](https://github.com/folke/lazy.nvim)
- Modern folding using `nvim-ufo` and `statuscol.nvim`
  - Click a line number to fold or unfold the surrounding code
- Fixes common LSP completion error `bufnr: expected number, got function` by normalizing
  buffer numbers in LSP requests
