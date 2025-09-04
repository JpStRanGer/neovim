return {
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeHide", "UndotreeFocus" },
        keys = {
            -- Velg en tast som ikke krasjer med LazyVim sine UI-taster.
            { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
        },
        init = function()
            -- GUI/oppførsel
            vim.g.undotree_WindowLayout = 2 -- tre til høyre, diff under
            vim.g.undotree_SplitWidth = 35
            vim.g.undotree_DiffpanelHeight = 12
            vim.g.undotree_SetFocusWhenToggle = 1 -- fokuser vinduet når du åpner
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_HighlightChangedText = 1
            vim.g.undotree_HighlightChangedWithSign = 1
            vim.g.undotree_TreeNodeShape = "◉"
            vim.g.undotree_TreeVertShape = "│"
            vim.g.undotree_TreeSplitShape = "╱"
            vim.g.undotree_TreeReturnShape = "╲"
        end,
    },
}
