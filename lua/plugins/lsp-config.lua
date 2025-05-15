
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
    -- Mason package manager
    {
        "williamboman/mason.nvim",
        version = "1.*",
        config = function()
            require("mason").setup()
        end,
    },

    -- Mason integration with lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        version = "1.*",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "lua_ls",
                    -- "tsserver", -- Merk: tsserver, ikke ts_ls
                    "pylsp",
                    "bashls",
                },
                handlers = {
                    -- Default handler
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    -- Custom handler for Python LSP
                    pylsp = function()
                        require("lspconfig").pylsp.setup({
                            capabilities = capabilities,
                            settings = {
                                pylsp = {
                                    plugins = {
                                        pycodestyle = { maxLineLength = 100 },
                                        autopep8 = { enabled = true },
                                        mypy = { enabled = true },
                                        rope = { enabled = true },
                                        black = { enabled = true },
                                        ruff = { enabled = true },
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },

    -- Core LSP settings and keymaps
    {
        "neovim/nvim-lspconfig",
        config = function()
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
            vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to Definition (Telescope)" })
            vim.keymap.set("n", "gp", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
            vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action (Visual)" })

            vim.keymap.set("n", "<leader>sf", function()
                builtin.lsp_document_symbols({
                    symbols = { "Function", "Method" },
                })
            end, { desc = "Search Functions" })
        end,
    },
}
