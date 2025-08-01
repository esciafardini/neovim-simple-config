return {
  "Olical/conjure",
  ft = { "clojure", "fennel", "python" },   -- etc
  lazy = true,
  init = function()
    vim.g["conjure#mapping#doc_word"] = "gk"
    vim.keymap.set('n', '<leader>cs', ':ConjureConnect local.aclaimant.com 7000<cr>')
    vim.keymap.set('n', '<leader>cj', ':ConjureConnect local.aclaimant.com 7001<cr>')
    vim.keymap.set('n', '<leader>ca', ':ConjureConnect local.aclaimant.com 7002<cr>')
    -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
    -- vim.g["conjure#debug"] = true
  end,
}
