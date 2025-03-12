return {
    "goolord/alpha-nvim",
    dependencies = {
        "echasnovski/mini.icons",
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        -- require'alpha'.setup(require'alpha.themes.theta'.config)
        local alpha = require("alpha")
        -- local dashboard = require("alpha.themes.dashboard")
        local dashboard = require("alpha.themes.startify")

        dashboard.section.header.val = {
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
        }
        dashboard.section.header.opts.position = "center"

        -- -- Set menu
        -- dashboard.section.buttons.val = {
        --     dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
        --     dashboard.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
        --     dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        --     dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
        --     dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
        -- }

        alpha.setup(dashboard.opts)
    end,
}
