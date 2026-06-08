return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			-- "treesitter" dropped: it crashes on C++ with the frozen
			-- nvim-treesitter master (locals.lua :parent() on a nil node).
			-- LSP (clangd) gives better symbol highlighting anyway; regex is the fallback.
			providers = { "lsp", "regex" },
			delay = 100,
			filetypes_denylist = { "dirbuf", "dirvish", "fugitive" },
			under_cursor = true,
			large_file_cutoff = 10000,
		})

		local function set_illuminate_hl()
			vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#3d59a1", fg = "#ffffff", underline = true, bold = true })
			vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3d59a1", fg = "#ffffff", underline = true, bold = true })
			vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3d59a1", fg = "#ffffff", underline = true, bold = true })
		end

		set_illuminate_hl()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_illuminate_hl })
	end,
}
