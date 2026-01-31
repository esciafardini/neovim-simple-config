return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    overrides = function(colors)
      local theme = colors.theme
      return {
        LineNr = { fg = theme.syn.string, bg = theme.ui.bg_m3 },
        CursorLineNr = { fg = theme.syn.number, bg = theme.ui.bg_m3, bold = true },
        SignColumn = { bg = theme.ui.bg_m3 },
      }
    end,
  },
  config = function()
    vim.cmd.colorscheme("kanagawa")
  end,
}
