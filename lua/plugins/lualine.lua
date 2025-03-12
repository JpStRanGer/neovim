return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require('lualine').setup({
            options = {
                theme = "dracula"
            }
        })
        vim.opt.guifont = "Hack Nerd Font:h12"
    end
}
