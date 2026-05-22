return {
	"ray-x/lsp_signature.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<C-k>",
			function()
				require("lsp_signature").toggle_float_win()
			end,
			mode = "i",
			desc = "Toggle signature help",
		},
	},
	config = function()
		require("lsp_signature").setup({
			bind = true,
			floating_window = true,
			floating_window_above_cur_line = true,
			fix_pos = true,         -- hold vinduet åpent gjennom hele (...) selv ved cursorflytt
			always_trigger = true,  -- oppdater på hver cursorbevegelse innenfor kallet
			hint_enable = true,     -- virtuell tekst inline — kan ikke dekkes av cmp-popup
			hint_prefix = "» ",
			hi_parameter = "IncSearch",
			handler_opts = { border = "rounded" },
		})
	end,
}
