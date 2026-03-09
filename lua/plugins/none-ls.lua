return {
	"nvimtools/none-ls.nvim",
	keys = {
		{
			"<leader>gf",
			function()
				local bufnr = vim.api.nvim_get_current_buf()
				local has_null_ls = false

				for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
					if client.name == "null-ls" and client:supports_method("textDocument/formatting") then
						has_null_ls = true
						break
					end
				end

				if not has_null_ls then
					vim.notify("none-ls/null-ls formatter is not attached to this buffer", vim.log.levels.WARN)
					return
				end

				local format_opts = {
					filter = function(client)
						return client.name == "null-ls"
					end,
				}

				-- Support visual char/line/block mode by formatting full selected lines.
				local mode = vim.fn.mode(1)
				if mode:sub(1, 1) ~= "n" then
					local start_line = vim.fn.getpos("'<")[2]
					local end_line = vim.fn.getpos("'>")[2]
					if start_line > end_line then
						start_line, end_line = end_line, start_line
					end

					format_opts.range = {
						["start"] = { start_line, 0 },
						["end"] = { end_line, math.max(0, vim.fn.col({ end_line, "$" }) - 1) },
					}
				end

				vim.lsp.buf.format(format_opts)
			end,
			mode = { "n", "x" },
			desc = "Format via none-ls",
		},
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
			},
		})
	end,
}
