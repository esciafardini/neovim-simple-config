return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    colors = {
      palette = {
        carpYellow   = "#b0cfd1",
        autumnOrange = "#95bec1",
        autumnYellow = "#bdd8d9",
      },
    },
    overrides = function(colors)
      local theme = colors.theme
      return {
        LineNr = { fg = theme.syn.type, bg = theme.ui.bg_m3 },
        CursorLineNr = { fg = theme.syn.string, bg = theme.ui.bg_m3, bold = true },
        SignColumn = { bg = theme.ui.bg_m3 },
      }
    end,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd.colorscheme("kanagawa")
  end,
}
