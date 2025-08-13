return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")

          function _G.toggle_fold()
            local line = vim.fn.getmousepos().line
            vim.api.nvim_win_set_cursor(0, { line, 0 })
            vim.cmd("normal! za")
          end

          require("statuscol").setup({
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.toggle_fold" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.toggle_fold" },
              { text = { "%s" } },
            },
          })
        end,
      },
    },
    config = function()
      require("ufo").setup()
    end,
  },
}
