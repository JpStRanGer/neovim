# Keymap v2 plan (copy/paste guide)

Dette er en konkret plan for `<leader>`-prefikser i hele repoet.
Målet er: lett å huske, lett å utvide, lett å lese i which-key.

## Prefix-struktur

- `<leader>f` = **Find** (Telescope, søk, filer, buffers)
- `<leader>g` = **Git + Format**
- `<leader>l` = **LSP jumps/diagnostics**
- `<leader>c` = **Code actions**
- `<leader>r` = **Refactor / Rename**
- `<leader>o` = **Ollama**
- `<leader>t` = **Tools**
- `<leader>s` = **Symbols / Surround**
- `<leader>d` = **Docs (generate comments)**
- `<leader>h` = **Highlight / UI utility**
- `<leader>u` = **Undo / Redo**
- `<leader>U` = **Undo tree**
- `<leader>?` = **which-key for current buffer**

## Foreslått map-tabell (v2)

| Key | Handling | Status |
|---|---|---|
| `<leader>?` | Vis buffer keymaps | aktiv |
| `<leader>h` | Fjern søkehighlight | aktiv |
| `<leader>ff` | Finn filer | aktiv |
| `<leader>fg` | Live grep | aktiv |
| `<leader>fb` | Bufferliste | aktiv |
| `<leader>fh` | Hjelpetags | aktiv |
| `<leader>fs` | Søk ord under cursor | aktiv |
| `<leader>fr` | LSP references | aktiv |
| `<leader>fd` | Diagnostikk under cursor | aktiv |
| `<leader>ld` | LSP definitions | aktiv |
| `<leader>ca` | Code actions (normal + visual extract) | aktiv |
| `<leader>sf` | Finn funksjoner/metoder i fil | aktiv |
| `<leader>rn` | Rename symbol | aktiv |
| `<leader>gf` | Format via none-ls | aktiv |
| `<leader>gb` | Git blame line | aktiv |
| `<leader>gB` | Toggle inline blame | aktiv |
| `<leader>d` | Generer doc-kommentar | aktiv |
| `<leader>cp` | Color picker | aktiv |
| `<leader>tt` | Insert template | aktiv |
| `<leader>oo` | Ollama prompt | aktiv |
| `<leader>oG` | Ollama generate code prompt | aktiv |
| `<leader>s?` | Surround cheatsheet | aktiv |
| `<leader>uu` | Undo | aktiv |
| `<leader>ur` | Redo | aktiv |
| `<leader>U` | Toggle undotree | aktiv |

## Regler for nye keymaps

1. Nye keymaps skal ha `desc`.
2. Plugin-keymaps legges i pluginens `keys = { ... }`.
3. Global state legges i `lua/core/keymaps.lua`.
4. If it is leader-map: legg inn også i `whichKey.spec`.
