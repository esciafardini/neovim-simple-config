local function show_which_key_help()
  require("which-key").show({ global = false })
end

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>c", group = "Conjure" },
      { "<leader>f", group = "Telescope" },
      { "<leader>a", group = "Dashboard" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Treesitter" },
      { "<leader>g", group = "Git" },
    })
  end,
  keys = {
    { "<leader>?", show_which_key_help, desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
