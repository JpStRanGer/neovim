-- ════════════════════════════════════════════════════════════════════════
--  nvim-treesitter på MAIN-branchen (rewriten for nvim 0.11+/0.12)
-- ════════════════════════════════════════════════════════════════════════
-- Migrert fra `master` (frozen, inkompatibel med nvim 0.11+). På master
-- krasjet master sin injection-håndtering nvim-kjernen med
-- "attempt to call method 'range' (a nil value)" (treesitter.lua:196), som
-- igjen tok ned treesitter-context — typisk noen sekunder etter at en .sh
-- ble åpnet og en injisert parser var auto-installert. To stopgaps lå før
-- her (en `set-lang-from-info-string!`-shim + en `get_range` nil-vakt); BEGGE
-- er fjernet i denne migreringen siden main håndterer injections korrekt.
--
-- DEN STORE FORSKJELLEN master → main:
--   master: én stor `require("nvim-treesitter.configs").setup{...}` som både
--           installerte parsere (ensure_installed/auto_install) OG skrudde på
--           highlight/indent/textobjects automatisk.
--   main:   installasjon og funksjoner er SKILT.
--           1) Parsere installeres eksplisitt med `require("nvim-treesitter").install{...}`
--              (ingen auto_install lenger).
--           2) Funksjoner skrus på av OSS, per filtype, i en FileType-autocmd:
--              highlight kommer fra nvim-kjernen (`vim.treesitter.start()`),
--              indent fra `nvim-treesitter`.indentexpr().
--           (Folding eies av nvim-ufo — derfor rører vi IKKE foldexpr her.)
-- ════════════════════════════════════════════════════════════════════════
return {
	-- Auto-lukk/omdøp HTML/JSX-tagger. Uavhengig plugin (egen `main`), urørt.
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},

	-- Viser hvilken funksjon/blokk man er inni, klistret øverst. Bruker nvim-
	-- kjernens treesitter (ikke nvim-treesitter), så den er branch-uavhengig.
	-- Krasjet før pga. master sine ødelagte injections; med main er den trygg.
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = "─",
			})
			vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#3c3836", bold = true })
		end,
	},

	-- Textobjects på MAIN: lastes som dependency av nvim-treesitter under, og
	-- konfigureres derfra (se config-funksjonen nederst). Bare spec-en her.
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- main: last ved oppstart så FileType-autocmden er på plass
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			-- ── Egendefinert d2-parser ──────────────────────────────────────
			-- Grammatikken (ravsii/tree-sitter-d2) har pre-generert src/parser.c,
			-- så ingen `generate` trengs. Highlight/injection-queries for d2 ligger
			-- vendret i queries/d2/. Vi registrerer parseren TO steder:
			--   • direkte nå, så `install()`-kallet under ser d2 med en gang, og
			--   • i en `User TSUpdate`-autocmd, så senere `:TSUpdate` (build) også
			--     kjenner den (autocmden fyrer først da, ikke ved oppstart).
			local function register_d2()
				require("nvim-treesitter.parsers").d2 = {
					install_info = {
						url = "https://github.com/ravsii/tree-sitter-d2",
						branch = "main",
					},
				}
			end
			vim.api.nvim_create_autocmd("User", { pattern = "TSUpdate", callback = register_d2 })
			register_d2()
			-- Knytt d2-parseren til d2-filtypen (filtypen settes i core/filetypes.lua).
			vim.treesitter.language.register("d2", { "d2" })

			-- ── Installer parsere ───────────────────────────────────────────
			-- Eksplisitt liste (main har ingen auto_install). Union av tidligere
			-- ensure_installed + det auto_install faktisk hadde hentet på maskinen.
			-- markdown_inline er med fordi markdown-injections (kodeblokker) krever den.
			require("nvim-treesitter").install({
				"bash",
				"c",
				"cmake",
				"cpp",
				"css",
				"csv",
				"d2",
				"diff",
				"elixir",
				"heex",
				"html",
				"htmldjango",
				"hyprlang",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"markdown_inline",
				"query",
				"toml",
				"vim",
				"vimdoc",
			})

			-- ── Skru på funksjoner per filtype ──────────────────────────────
			-- main skrur ingenting på automatisk. Vi gjør det i én FileType-autocmd.
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					-- Highlight fra nvim-kjernen. pcall: parseren kan mangle for en
					-- ukjent/ikke-installert filtype — da hopper vi bare over.
					local ok = pcall(vim.treesitter.start)
					if ok then
						-- Treesitter-innrykk (matcher tidligere `indent.enable=true`).
						-- Settes KUN når TS faktisk er aktiv, så vi ikke overstyrer
						-- den innebygde indenten for filtyper uten parser.
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			-- ── Textobjects (main-API) ──────────────────────────────────────
			-- master hadde en stor `textobjects = { move/select.keymaps }`-tabell.
			-- main flytter dette til eksplisitte funksjonskall + egne keymaps.
			-- Vi beholder NØYAKTIG de samme tastene:
			--   as       → velg switch-blokk         (@switch.outer)
			--   ]c / [c  → hopp til neste/forrige case (@case.label)
			-- Captures defineres i queries/cpp/textobjects.scm (dette repoet).
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			vim.keymap.set({ "x", "o" }, "as", function()
				select.select_textobject("@switch.outer", "textobjects")
			end, { desc = "Select switch block (treesitter)" })
			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				move.goto_next_start("@case.label", "textobjects")
			end, { desc = "Next case label (treesitter)" })
			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				move.goto_previous_start("@case.label", "textobjects")
			end, { desc = "Prev case label (treesitter)" })
		end,
	},
}
