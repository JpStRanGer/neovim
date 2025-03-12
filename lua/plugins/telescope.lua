return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim'
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
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
            vim.opt.guifont = "Hack Nerd Font:h12"
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    },
}
