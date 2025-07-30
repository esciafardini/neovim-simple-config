return {
  "rebelot/kanagawa.nvim",
  config = function()
    vim.cmd.colorscheme("kanagawa-wave")
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#c0a36e' })
  end,
}
