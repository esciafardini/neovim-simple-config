return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  opts = {},
  config = function()
    local neotree = require("neo-tree")
    neotree.setup({
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    })
    vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<cr>", { desc = "File Explorer" })
  end,
}
