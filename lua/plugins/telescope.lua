return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
			{ "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
			{ "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
			{ "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
			{ "<leader>fs", function() require("telescope.builtin").grep_string() end, desc = "Search word under cursor" },
			{ "<leader>fr", function() require("telescope.builtin").lsp_references({ fname_width = 60, trim_text = true }) end, desc = "LSP references" },
			{ "<leader>fd", vim.diagnostic.open_float, desc = "Line diagnostics" },
			{ "<leader>ld", function() require("telescope.builtin").lsp_definitions() end, desc = "LSP definitions" },
		},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
