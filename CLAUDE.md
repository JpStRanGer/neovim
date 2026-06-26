# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Neovim config loaded from `~/.config/nvim`. Entry point is `init.lua`, which bootstraps `lazy.nvim`, loads core modules, then `require("lazy").setup("plugins")` auto-loads every file in `lua/plugins/`.

There is no build or test pipeline. "Running" this codebase means launching `nvim` — changes take effect on the next start, or immediately via `:source %` / `:Lazy reload <plugin>`.

## Common in-editor commands

- `:Lazy` — plugin manager UI (install/update/clean). `:Lazy sync` applies the lockfile.
- `:Mason` — install/update LSP servers, formatters, linters managed by Mason.
- `:checkhealth` — diagnose plugin/LSP/provider issues; run this first when something is broken.
- `:LspInfo` — show attached LSP clients for the current buffer. Use to verify `null-ls` is attached when `<leader>gf` does nothing.
- `:TSUpdate` — rebuild treesitter parsers.
- `lazy-lock.json` is committed and is the source of truth for plugin versions.

## Architecture

Three-layer module structure under `lua/`:

- `lua/vim-options.lua` — global `vim.opt`/`vim.g` and a `BufWritePre` autocmd that auto-creates parent directories.
- `lua/core/` — options-adjacent global state that isn't a plugin: `keymaps.lua` (global, non-plugin maps) and `filetypes.lua` (`vim.filetype.add`).
- `lua/plugins/*.lua` — one lazy.nvim spec per file. `lazy.setup("plugins")` imports all of them. Order of loading is controlled by `event`/`cmd`/`keys`/`priority`, not filenames.

### Maintenance rule (repo invariant)

> Each file in `lua/plugins/` should contain only the lazy-spec for that plugin — no global editor state.

Concretely:

- Plugin-specific keymaps go in that plugin's `keys = { ... }` table (this also gives lazy-loading for free).
- Global, non-plugin maps go in `lua/core/keymaps.lua`.
- Every leader-prefixed map must also be registered in `lua/plugins/whichKey.lua`'s `spec` (group label or desc) so `<leader>?` stays accurate.
- Every keymap needs a `desc`.

Keymap namespace contract is documented in `docs/KEYMAP_V2_PLAN.md` — when adding a new `<leader>x...` map, follow the prefix table there (`f`=Find, `g`=Git/Format, `l`=LSP, `c`=Code, `r`=Refactor, `o`=Ollama, `t`=Tools, `s`=Symbols/Surround, `d`=Docs, `h`=Clear highlight, `u`=Undo/Redo, `U`=Undotree).

### Formatter policy (single owner: none-ls)

Formatting is owned exclusively by `none-ls` (`lua/plugins/none-ls.lua`), triggered by `<leader>gf` in normal and visual modes. The keymap explicitly filters `vim.lsp.buf.format` to `client.name == "null-ls"` so no other LSP formats the buffer.

Consequences — preserve these when editing LSP config:

- `pylsp` has `autopep8`, `black`, `yapf` disabled in `lua/plugins/lsp-config.lua` on purpose. Do not re-enable them.
- New formatters are added as `null_ls.builtins.formatting.*` sources in `none-ls.lua`, not via LSP server settings.
- If `<leader>gf` silently does nothing, the likely cause is that `null-ls` isn't attached to the buffer — check with `:LspInfo`.

### LSP setup flow

`lua/plugins/lsp-config.lua` uses the newer `vim.lsp.config(name, {...})` API (not `lspconfig.<name>.setup`) and relies on `mason-lspconfig`'s `automatic_enable = true` to enable servers. Capabilities are built once from `cmp_nvim_lsp.default_capabilities()` with `offsetEncoding` cleared (clangd compatibility) and reused across servers.

Ensured servers via Mason: `clangd`, `lua_ls`, `pylsp`, `bashls`. `clangd` has a custom `--query-driver` list covering `arm-none-eabi-g++`, `xtensa-esp*-elf-g++`, `riscv32-esp-elf-g++` for embedded cross-compilers — do not drop these when editing its `cmd`.

`cmake-language-server` is intentionally NOT in `ensure_installed`. On Fedora 44 (Python 3.14) Mason fails to install it because the PyPI metadata caps Python at `<3.14`. Install it manually instead and let `vim.lsp.enable("cmake")` start it from PATH:

```
pip install --user --break-system-packages --ignore-requires-python 'pygls<2' cmake-language-server
```

(`pygls<2` is required because cmake-language-server 0.1.11 still uses the pygls 1.x API.) Do not re-add `cmake` to `ensure_installed`.

### Completion

`nvim-cmp` is configured in exactly one place: `lua/plugins/completions.lua`. `lsp-config.lua` must not call `cmp.setup()` again (doing so reintroduces a prior double-configuration bug). Capabilities flow one-way: cmp_nvim_lsp → lsp-config, never the reverse.

### Treesitter (main branch)

`lua/plugins/treesitter.lua` runs `nvim-treesitter` on the **`main`** branch (the nvim 0.11+ rewrite), migrated from the frozen `master` branch on 2026-06-26. The migration removed two stopgap shims that previously patched a `master`-only injection crash (`attempt to call method 'range' (a nil value)` at `treesitter.lua:196`, which took down treesitter-context a few seconds after opening a `.sh` with an injected/auto-installed language). `main` handles injections correctly, so the shims are gone — do not re-add them.

Key differences from the old `master` setup, preserve these:

- **No `require("nvim-treesitter.configs").setup{}`** — that API does not exist on `main`. Installation and features are separate.
- **Parsers are installed explicitly** via `require("nvim-treesitter").install({...})` (no `auto_install`). The list is the union of the old `ensure_installed` plus what `auto_install` had actually fetched on this machine. `markdown_inline` is required for markdown fenced-code injections. When adding a language, add it to that list. Note: `jsonc` is NOT a `main`-branch parser (only `json` is) — installing it logs `skipping unsupported language: jsonc`, so it's kept out of the list and the `jsonc` filetype is mapped to the `json` parser via `vim.treesitter.language.register("json", { "jsonc" })`.
- **Features are enabled per-filetype in a `FileType` autocmd**: `vim.treesitter.start()` (highlight, from nvim core) and `indentexpr` (only when TS is active). **Folding is owned by `nvim-ufo`** — do NOT set `foldexpr` here.
- **Custom `d2` parser** is registered via `require("nvim-treesitter.parsers").d2 = {...}` both directly (so `install()` sees it) and in a `User TSUpdate` autocmd (so `:TSUpdate`/build re-knows it), then `vim.treesitter.language.register("d2", {"d2"})`. Highlight/injection queries for d2 are vendored under `queries/d2/`.
- **Textobjects** (`nvim-treesitter-textobjects`, also `main`) uses the new function API, not a `keymaps` table: `require("...select").select_textobject(query, "textobjects")` and `require("...move").goto_next_start/goto_previous_start(query, "textobjects")`. The `as` / `]c` / `[c` maps target `@switch.outer` / `@case.label`, defined in `queries/cpp/textobjects.scm` (which starts with `; extends` so it augments rather than replaces the plugin's cpp textobjects).

Parsers now live in `stdpath('data')/site/parser` (main's location), not `lazy/nvim-treesitter/parser`.

### Local/experimental plugins

`lua/plugins/test.lua` loads the local plugin at `lua/myplugin/` only when `NVIM_ENABLE_LOCAL_TEST=1`. Keep this gate — the plugin is machine-specific and breaks on fresh clones.

### Misc conventions

- Leader is `<space>`, localleader is `\`.
- Clipboard is unified with the system (`unnamed,unnamedplus`); cmdline `<C-v>` is mapped to `<C-r>+` for paste inside `/` and `:`.
- Folding uses `nvim-ufo` + `statuscol.nvim`; clicking a line number in the statuscolumn toggles a fold via `_G.toggle_fold`.
- Colorscheme is `vscode` (transparent); `lualine` is configured in `lualine.lua` only — do not re-setup it from the colorscheme file.

## Reference docs in-repo

- `README.md` — user-facing top-20 keymap cheat sheet and formatter policy summary.
- `docs/KEYMAP_V2_PLAN.md` — authoritative `<leader>` prefix table; consult before adding maps.
- `docs/REPO_GJENNOMGANG.md` — Norwegian-language architectural review with the rationale behind the current structure (single cmp owner, single lualine owner, gated local test plugin, etc.). Useful context when a change seems to contradict the current layout.
