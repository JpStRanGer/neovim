return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 20,
		open_mapping = [[<C-\>]],
		shade_terminals = true,
		shading_factor = "1",
		direction = "float",
		float_opts = {
			border = "curved",
		},
	},
	keys = {
		{ "<C-t>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
		{
			"<leader>es",
			function()
				-- Seriell monitor: standard 115200 baud, endre port ved behov
				local port = vim.fn.input("Seriell port [/dev/ttyUSB0]: ", "/dev/ttyUSB0")
				if port == "" then port = "/dev/ttyUSB0" end
				require("toggleterm.terminal").Terminal
					:new({ cmd = "picocom -b 115200 " .. port, direction = "float" })
					:toggle()
				vim.notify("Avslutt picocom: Ctrl+A Ctrl+A Ctrl+X", vim.log.levels.INFO)
			end,
			desc = "Embedded: seriell monitor",
		},
		{
			"<leader>eb",
			function()
				require("toggleterm.terminal").Terminal
					:new({ cmd = "pio run", direction = "float", close_on_exit = false })
					:toggle()
			end,
			desc = "Embedded: bygg (PlatformIO)",
		},
		{
			"<leader>eu",
			function()
				require("toggleterm.terminal").Terminal
					:new({ cmd = "pio run -t upload", direction = "float", close_on_exit = false })
					:toggle()
			end,
			desc = "Embedded: flash (PlatformIO)",
		},
	},
}
