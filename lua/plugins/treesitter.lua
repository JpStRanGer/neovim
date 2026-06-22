return {
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},
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
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
		},
		config = function()
			-- d2 is not in the master-branch parser registry, so register it
			-- manually against the upstream grammar. Highlight/injection queries
			-- are vendored under queries/d2/ since master ships none for it.
			local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
			parser_configs.d2 = {
				install_info = {
					url = "https://github.com/ravsii/tree-sitter-d2",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "d2",
			}

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"cmake",
					"cpp",
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"elixir",
					"heex",
					"javascript",
					"html",
					"htmldjango",
					"d2",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = { ["]c"] = "@case.label" },
						goto_previous_start = { ["[c"] = "@case.label" },
					},
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["as"] = "@switch.outer",
						},
					},
				},
			})

			-- Neovim 0.11+ compat shim for nvim-treesitter (master, frozen).
			-- Its `set-lang-from-info-string!` directive (used by the bundled
			-- markdown injections.scm for fenced code blocks) assumes
			-- match[capture_id] is a single TSNode. Since 0.11 it is always a
			-- list of nodes, so the original passes a table to get_node_text and
			-- crashes deep in treesitter with
			--   "attempt to call method 'range' (a nil value)"
			-- which also takes down treesitter-context. Re-register a version
			-- that unwraps the node list. Drop this once we migrate to the
			-- nvim-treesitter `main` branch.
			local aliases =
				{ ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
			require("vim.treesitter.query").add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local nodes = match[pred[2]]
				local node = type(nodes) == "table" and nodes[#nodes] or nodes
				if not node then
					return
				end
				local alias = vim.treesitter.get_node_text(node, bufnr):lower()
				local ft = vim.filetype.match({ filename = "a." .. alias })
				metadata["injection.language"] = ft or aliases[alias] or alias
			end, { force = true })
		end,
	},
}
