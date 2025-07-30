return {
  "Olical/conjure",
  config = function()
    vim.g["conjure#mapping#doc_word"] = "gk"
    vim.keymap.set('n', '<leader>cs', ':ConjureConnect local.aclaimant.com 7000<cr>')
    vim.keymap.set('n', '<leader>cj', ':ConjureConnect local.aclaimant.com 7001<cr>')
    vim.keymap.set('n', '<leader>ca', ':ConjureConnect local.aclaimant.com 7002<cr>')
  end
}
