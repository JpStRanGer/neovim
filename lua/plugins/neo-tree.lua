return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    window = {
        mappings = {
            ["P"] = {
                "toggle_preview",
                config = {
                    use_float = true,
                    -- use_float = false,
                    use_image_nvim = true,
                    title = 'Neo-tree Preview',
                },
            },
            ["v"] = "open_vsplit", -- Press 'v' to open in vertical splitt
            ["s"] = "open_split", -- Press 's' to open in horizontal splitt
        }
    },
    config = function()
        vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')
    end
}
