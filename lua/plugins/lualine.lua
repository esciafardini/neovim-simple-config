return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local palette = require("kanagawa.colors").setup().palette

    require('lualine').setup({
      options = {
        theme = 'auto'
      },
      sections = {
        lualine_c = {
          { 'filename', path = 1, color = { fg = palette.sumiInk0, bg = palette.fujiWhite } },
          { function() return ' 🌑 ' end, color = { bg = palette.sumiInk4 }, padding = { left = 1, right = 0 } },
        },
        lualine_x = {
          { 'filetype', icon_only = true },
          'lsp_status'
        },
      },
    })
  end
}
