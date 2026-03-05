return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- opts = function(_, opts)
        --     opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        --         winblend = 0,  -- ✅ Adjust transparency (0 = opaque, 100 = fully transparent)
        --         layout_config = {
        --             prompt_position = "top",
        --         },
        --         sorting_strategy = "ascending",
        --     })
        -- end,
        -- opts = {
        --     defaults = {
        --         -- winblend = 20, -- Adjust transparency (0= opaque, 100 = fully transparent)
        --         layout_config = {
        --             prompt_position = "top",
        --         },
        --         sorting_strategy = "ascending",
        --     },
        -- },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
            vim.keymap.set("n", "<leader>hh", builtin.lsp_definitions, { desc = "Telescope help tags" })
            vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Search symbol under cursor." })
            vim.keymap.set("n", "<leader>fd", vim.diagnostic.open_float, { desc = "Show all LSP diagnostics" })
            vim.keymap.set("n", "<leader>fa", function()
                -- builtin.lsp_document_symbols({ symbols = "function", "method" })
                builtin.lsp_references({
                    fname_width = 60,
                    trimg_text = true,
                })
            end, { desc = "Show all functions/methods in file" })
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
