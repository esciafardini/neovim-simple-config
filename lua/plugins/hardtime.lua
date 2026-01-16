return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  opts = {
    max_count = 2,
    disable_mouse = true,
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
    hint = true,   -- show hints for better motions
    notification = true,
  }
}
