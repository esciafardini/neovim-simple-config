return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto'
      },
      sections = {
        lualine_c = {
           'filename',
          { function() return ' 🕯 ' end, padding = { left = 1, right = 0 } },
        },
        lualine_x = {
          { 'filetype', icon_only = true },
          { 'lsp_status' }
        },
      },
    })
  end
}
