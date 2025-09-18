return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>c", group = "Conjure" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Treesitter" },
      { "<leader>g", group = "Git" },
    })
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
