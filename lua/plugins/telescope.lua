return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		keys = {
			{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
			{ "<leader>fa", function() require("telescope.builtin").find_files({ no_ignore = true, hidden = true }) end, desc = "Find ALL files (incl. gitignored + hidden)" },
			{ "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
			{
			"<leader>fgi",
			function()
				vim.ui.input({ prompt = "File types (e.g. *.cpp,*.h): " }, function(input)
					if input == nil then return end
					local globs = vim.tbl_map(vim.trim, vim.split(input, ",", { trimempty = true }))
					require("telescope.builtin").live_grep(#globs > 0 and { glob_pattern = globs } or nil)
				end)
			end,
			desc = "Live grep",
		},
			{ "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
			{ "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
			{ "<leader>fs", function() require("telescope.builtin").grep_string() end, desc = "Search word under cursor" },
			{ "<leader>fr", function() require("telescope.builtin").lsp_references({ fname_width = 60, trim_text = true }) end, desc = "LSP references" },
			{ "<leader>fd", vim.diagnostic.open_float, desc = "Line diagnostics" },
			{ "<leader>ld", function() require("telescope.builtin").lsp_definitions() end, desc = "LSP definitions" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})
			telescope.load_extension("ui-select")
		end,
	},
}
