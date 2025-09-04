return {
    {

        "williamboman/mason.nvim",
        version = "1.*",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        version = "1.*",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Fallback if "cmp-nvim-lsp" is not loaded corectly
            if cmp_ok then
                capabilities = cmp_lsp.default_capabilities(capabilities)
            end
    
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "lua_ls", "pylsp", "bashls" },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({ capabilities = capabilities })
                    end,
                    clangd = function()
                        require("lspconfig").clangd.setup({
                            capabilities = capabilities,
                            cmd = {
                                "clangd",
                                "--background-index",
                                "--cross-file-rename",
                                "--function-arg-placeholders",
                                "--header-insertion=iwyu",
                                "--completion-style=detailed",
                                "--all-scopes-completion",
                                "--pch-storage=memory",
                            },
                        })
                    end,
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
    {
        "neovim/nvim-lspconfig",
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
            vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to Definition (Telescope)" })
            vim.keymap.set("n", "gp", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
            vim.keymap.set("v", "<leader>ca", function()
                vim.lsp.buf.code_action({
                    context = { only = { "refactor.extract" } },
                    range = {
                        ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                        ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
                    },
                })
            end, { desc = "Code Action (Visual) - Extract Function" })
            vim.keymap.set("n", "<leader>sf", function()
                builtin.lsp_document_symbols({ symbols = { "Function", "Method" } })
            end, { desc = "Search Functions" })
        end,
    },
}
