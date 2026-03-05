local function open_surround_tips()
	local lines = vim.split(
		[[
Surround.vim – quick tips

Add:
  ys{motion}{char}    Add surround
  yss                 Add surround to whole line

Change:
  cs{old}{new}        Change surround

Delete:
  ds{char}            Delete surround

Examples:
  cs"'       "Hello"   → 'Hello'
  cs"<q>     "Hello"   → <q>Hello</q>
  ysiw]      Hello     → [Hello]
  yssb       Hello     → (Hello)
]],
		"\n",
		{ plain = true }
	)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "markdown"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"

	local win_opts = {
		style = "minimal",
		relative = "editor",
		width = 60,
		height = #lines,
		row = (vim.o.lines - #lines) / 2,
		col = (vim.o.columns - 60) / 2,
		border = "rounded",
	}

	vim.api.nvim_open_win(buf, true, win_opts)
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
	vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
end

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "classic",
		delay = 200,
		spec = {
			{ "<leader>c", group = "Code" },
			{ "<leader>cp", desc = "Pick color" },
			{ "<leader>d", desc = "Generate doc comment" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git/Format" },
			{ "<leader>h", desc = "Clear search highlight" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>o", group = "Ollama" },
			{ "<leader>r", group = "Refactor/Rename" },
			{ "<leader>s", group = "Search/Surround" },
			{ "<leader>t", group = "Tools" },
			{ "<leader>U", desc = "Toggle Undotree" },

			{ "ys", desc = "Add surround", mode = "n" },
			{ "yss", desc = "Add surround line", mode = "n" },
			{ "cs", desc = "Change surround", mode = "n" },
			{ "ds", desc = "Delete surround", mode = "n" },
			{ "S", desc = "Visual surround", mode = "v" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer keymaps (which-key)",
		},
		{ "<leader>s?", open_surround_tips, desc = "Surround cheatsheet" },
	},
	init = function()
		vim.api.nvim_create_user_command("SurroundTips", open_surround_tips, {})
	end,
}
