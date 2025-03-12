return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup{
            size = 20,
            open_mapping = [[<C-\>]],
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = '1',
            direction = 'float',    -- 'horizontal' | 'vertical' | 'float'
            float_opts = {
                border = 'curved',  -- 'single', 'double', 'shadow', 'curved'
                -- winblend = 20,      -- Adjust transparency (0 = opaque, 100 = fully transparent)
            }
        }

    end
}
