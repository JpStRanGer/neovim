# Gjennomgang av repoet: forslag for enklere styring og vedlikehold

Denne gjennomgangen er laget for å gjøre Neovim-oppsettet lettere å drifte over tid, med fokus på:

1. færre skjulte konflikter,
2. tydeligere struktur,
3. enklere feilsøking,
4. raskere oppstart.

## Prioritet 1 (høy effekt / lav risiko)

### 1) Samle all keymap-definisjon på ett sted
**Hvorfor:** Keymaps er spredd i `vim-options.lua` og flere pluginfiler. Det gir konfliktfare og gjør det vanskelig å vite "hva som eier hva".

**Observasjoner:**
- `<leader>h` settes globalt til `:nohlsearch` i `lua/vim-options.lua`, men brukes også i `myplugin` (hvis aktivert).
- `<C-c>` brukes i `colorpicker` i insert mode, som kan kollidere med forventet avbryt/interrupt-flow i terminaler.

**Anbefaling:**
- Opprett f.eks. `lua/core/keymaps.lua` for globale maps.
- La pluginfiler kun definere plugin-spesifikke maps under `keys = { ... }` i lazy-spec.

---

### 2) Fjern dobbel konfigurasjon av `nvim-cmp` og LSP-capabilities
**Hvorfor:** `cmp.setup()` kjøres både i `lua/plugins/completions.lua` og i `lua/plugins/lsp-config.lua`. Dette gjør oppførsel vanskelig å forutsi.

**Anbefaling:**
- Ha **én** eier av `cmp.setup()` (typisk `completions.lua`).
- La `lsp-config.lua` kun håndtere LSP-servere/capabilities.
- Eksporter capabilities fra en liten `lua/core/lsp.lua`-modul, og gjenbruk den.

---

### 3) Fjern/isolér testplugin fra daglig config
**Hvorfor:** `lua/plugins/test.lua` laster en lokal plugin via `~/.config/nvim/lua/myplugin`, som er miljøspesifikt og kan feile på andre maskiner.

**Anbefaling:**
- Flytt til egen lokal override-fil som ikke er versjonert (f.eks. `lua/local/plugins.lua`).
- Eventuelt gate med env-flagg (`if vim.env.NVIM_ENABLE_LOCAL_TEST == "1" then ... end`).

---

### 4) Rydd opp dobbel lualine-oppsett
**Hvorfor:** `lualine` settes opp både i `lua/plugins/lualine.lua` og inni `colorscheme.lua`. Det gir unødvendig overstyring og mer diff-støy.

**Anbefaling:**
- La `lualine.lua` være eneste sted for `require("lualine").setup(...)`.
- La theme-fil kun sette colorscheme/highlights.

---

## Prioritet 2 (stabilitet og lesbarhet)

### 5) Korriger plugin-spec i treesitter-filen
**Hvorfor:** I `lua/plugins/treesitter.lua` finnes en tabell med `vim.filetype.add(...)` direkte i pluginlisten. Det er uvanlig spec-form og vanskelig å lese/vedlikeholde.

**Anbefaling:**
- Flytt `vim.filetype.add(...)` til `lua/vim-options.lua` eller `lua/core/filetypes.lua`.
- Hold pluginfiler rene: én tabell per plugin.

---

### 6) Gjør formatter-strategien entydig
**Hvorfor:** Du har formattere både via LSP (`pylsp` med `black`/`ruff`) og via `none-ls` (`black`, `isort`, osv.). Dette kan gi dobbel formattering eller inkonsistente resultater.

**Anbefaling:**
- Velg én policy per språk:
  - Enten LSP-formatting,
  - eller `none-ls` som eneste formatter-kilde.
- Legg til `filter` i `vim.lsp.buf.format({ filter = ... })` for eksplisitt klientvalg.

---

### 7) Standardiser `lazy.nvim`-stil (`opts` over `config` der mulig)
**Hvorfor:** Flere plugins bruker tunge inline `config`-blokker og ad-hoc keymaps. `opts` + `keys` gir mer deklarativ og mindre feilutsatt konfig.

**Anbefaling:**
- Migrer gradvis pluginfiler til mønster:
  - `opts = { ... }`
  - `keys = { ... }`
  - `event`/`cmd` for lazy-loading

---

### 8) Reduser kommentert "historisk" kode i pluginfiler
**Hvorfor:** Mange store kommenterte blokker gjør det vanskeligere å finne aktiv logikk.

**Anbefaling:**
- Flytt historikk til commit-logg / `docs/notes.md`.
- Hold aktive pluginfiler korte og operative.

---

## Prioritet 3 (drift og onboarding)

### 9) Bedre README for drift
**Hvorfor:** README er kort og mangler driftsrutiner.

**Anbefaling:**
- Legg til:
  - krav (Neovim-versjon, verktøy som `clangd`, `black`, `isort`),
  - "første oppstart",
  - feilsøking (Mason/LSP/formatter),
  - oppgraderingsrutine (`:Lazy update`, lockfile-policy).

---

### 10) Innfør enkel modulstruktur
**Forslag:**
- `lua/core/` for options, keymaps, autocommands
- `lua/plugins/` for rene lazy-specs
- `lua/local/` for maskinspesifikke overrides (gitignored)
- `docs/` for beslutninger og conventions

Dette gjør repoet lettere å dele og videreutvikle.

---

## Konkrete "quick wins" (kan gjøres på 30–60 min)

1. Fjern `cmp.setup()` fra `lsp-config.lua`.
2. Flytt `vim.filetype.add(...)` ut av `treesitter.lua`.
3. Fjern lualine-setup fra `colorscheme.lua`.
4. Flytt `<leader>h` og andre globale maps til dedikert keymap-fil.
5. Deaktiver `lua/plugins/test.lua` i versjonert config.

---

## Forslag til vedlikeholdsregel

Bruk én enkel regel for nye endringer:

> "Hver pluginfil skal kun inneholde lazy-spec for pluginen, ikke global state for resten av editoren."

Denne regelen alene vil redusere vedlikeholdskost betydelig.
