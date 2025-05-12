return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			current_line_blame = false,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = vim.keymap.set

				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { buffer = bufnr, desc = "Git blame line" })

				map("n", "<leader>gB", function()
					gs.toggle_current_line_blame()
				end, { buffer = bufnr, desc = "Toggle inline blame" })
			end,
		})
	end,
}
