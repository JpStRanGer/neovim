
return {
  "danymat/neogen",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("neogen").setup({
      enabled = true,
      languages = {
        cpp = {
          template = {
            annotation_convention = "doxygen"
          }
        },
      },
    })

    -- Keymap: Press <leader>d to generate Doxygen comments
    vim.keymap.set(
      "n",
      "<leader>d",
      function() require("neogen").generate() end,
      { desc = "Generate Doxygen Comment" }
    )
  end,
  keys = {
    { "<leader>d", desc = "Generate Doxygen Comment" }
  }
}
