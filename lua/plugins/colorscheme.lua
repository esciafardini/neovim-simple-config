return {
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      overrides = function(colors)
        local theme = colors.theme
        return {
          LineNr = { fg = theme.syn.string, bg = theme.ui.bg_m3 },
          CursorLineNr = { fg = theme.syn.number, bg = theme.ui.bg_m3, bold = true },
          SignColumn = { bg = theme.ui.bg_m3 },
        }
      end,
    })
    -- set color scheme last
    vim.cmd.colorscheme("kanagawa")
  end,
} -- ✓
