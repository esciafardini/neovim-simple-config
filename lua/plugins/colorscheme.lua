return
{
  "rebelot/kanagawa.nvim",
  config = function()
    vim.cmd.colorscheme("kanagawa")
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#7FB4CA", bg = "#2A2A37" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#E6C384", bg = "#2A2A37", bold = true })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#2A2A37" })
  end,
}
