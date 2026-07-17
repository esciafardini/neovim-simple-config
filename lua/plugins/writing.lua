return {
  {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    opts = {
      window = {
        width = 72,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          cursorline = false,
        },
      },
      plugins = {
        twilight = { enabled = true },
      },
    },
  },
}
