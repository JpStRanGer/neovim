return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			-- Grupper (normal/visual)
			{ "y", group = "+yank/surround", mode = "n" },
			{ "c", group = "+change", mode = "n" },
			{ "d", group = "+delete", mode = "n" },
			{ "S", group = "+Surround (visual)", mode = "v" },

			-- ---- surround.vim kjerne ----
			-- Add
			{ "ys", desc = "Add surround (ys {motion} {char})", mode = "n" },
			{ "yss", desc = "Add surround to whole line", mode = "n" },

			-- Change / Delete
			{ "cs", desc = "Change surround (cs {old} {new})", mode = "n" },
			{ "ds", desc = "Delete surround (ds {char})", mode = "n" },

			-- Vanlige eksempler som hint (de er *ikke* egne mappings, bare beskrivelser):
			{ "ysi", desc = "ysiw] ⇒ [word] / ysiw<em> ⇒ <em>word</em>", mode = "n" },
			{ "yssb", desc = "Wrap line in ( )  (yss) / b = )", mode = "n" },

			-- Visual mode: S + {char/tag}
			{ "S", desc = "Visual surround: S{char} eller S<tag>", mode = "v" },

			-- Eksempel-hints for vanlige sekvenser:
			{ "cs" .. '"' .. "'", desc = [[" → '   (cs"'"")]], mode = "n" },
			-- cs"'<q> (quotes → <q>…</q>) – which-key klarer ikke vise hele sekvensen med <q>,
			-- men vi legger en kort forklaring her:
			{ "csq", desc = [[ " → <q>…</q>  (skriv egentlig: cs" <q>) ]], mode = "n" },

			-- Ryddig help-åpner på <leader>s?
			{ "<leader>s?", desc = "Open Surround.vim tips", mode = { "n", "v" } },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
		{
			"<leader>s?",
			function()
				local lines = vim.split(
					[[
Surround.vim – quick tips

Add:
  ys{motion}{char}    Add surround
  yss                 Add surround to whole line

Change:
  cs{old}{new}        Change surround (e.g. cs"' → " → ')

Delete:
  ds{char}            Delete surround (e.g. ds" → remove quotes)

Examples:
  cs"'       "Hello"   → 'Hello'
  cs"<q>     "Hello"   → <q>Hello</q>
  ysiw]      Hello     → [Hello]
  cs]{       [Hello]   → { Hello }
  yssb       Hello     → (Hello)
  ds{ds)     ({Hello}) → Hello
  ysiw<em>   Hello     → <em>Hello</em>
  V → S<p>   Visual mode surround
        ]],
					"\n",
					{ plain = true }
				)

				-- Lag et midlertidig buffer
				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.bo[buf].filetype = "markdown"
				vim.bo[buf].buftype = "nofile"
				vim.bo[buf].bufhidden = "wipe"

				-- Sett størrelse og posisjon
				local width = 60
				local height = #lines
				local opts = {
					style = "minimal",
					relative = "editor",
					width = width,
					height = height,
					row = (vim.o.lines - height) / 2,
					col = (vim.o.columns - width) / 2,
					border = "rounded",
				}

				local win = vim.api.nvim_open_win(buf, true, opts)

				-- Lukk vinduet med q eller <Esc>
				vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
				vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true })
			end,
			desc = "Surround.vim cheatsheet (popup)",
		},
	},
	init = function()
		-- Scratch-kommando med hele eksempellisten
		vim.api.nvim_create_user_command("SurroundTips", function()
			local buf = vim.api.nvim_create_buf(false, true)
			local lines = vim.split(
				[[
surround.vim – korte eksempler

cs"'      "Hello"        → 'Hello'
cs"<q>    "Hello"        → <q>Hello</q>
cst"      <q>Hello</q>   → "Hello"

ds"       "Hello"        → Hello
ysiw]     Hello          → [Hello]
cs]{      [ Hello ]      → { Hello }   (bruk } for uten mellomrom)
yssb / )  hele linja     → ( … )
ds{ds)                     fjern ( {    → tilbake til original

Visuell modus:
V (line) → S<p class="important">  → wrapper valgt område med taggen

Tips:
- Tekstobjekter: iw = inner word, i) = inni parens, osv.
- . (repeat) funker med ds/cs/yss hvis du har repeat.vim
      ]],
				"\n",
				{ plain = true }
			)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].buftype = "nofile"
			vim.bo[buf].bufhidden = "wipe"
			vim.bo[buf].swapfile = false
			vim.bo[buf].filetype = "markdown"
			vim.api.nvim_set_current_buf(buf)
		end, {})

		-- Map <leader>s? til å åpne tips
		vim.keymap.set({ "n", "v" }, "<leader>s?", "<cmd>SurroundTips<cr>", { desc = "Surround.vim tips" })
	end,
}
