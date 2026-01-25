return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    disabled_filetypes = { "gitsigns-blame" },
    max_count = 1,
    disable_mouse = false,
    disabled_keys = {
      ["<Up>"] = { "n" },
      ["<Down>"] = { "n" },
      ["<Left>"] = { "n" },
      ["<Right>"] = { "n" },
    },
    restricted_keys = {
      ["h"] = { "n", "x" },
      ["j"] = { "n", "x" },
      ["k"] = { "n", "x" },
      ["l"] = { "n", "x" },
    },
  },
}
