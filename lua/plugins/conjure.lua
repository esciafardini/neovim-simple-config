return {
  "Olical/conjure",
  ft = { "clojure", "fennel", "python" },   -- etc
  lazy = true,
  init = function()
    vim.g["conjure#mapping#doc_word"] = "gk"
    vim.keymap.set("n", "<leader>cs", ":ConjureConnect local.aclaimant.com 7000<cr>", { desc = "Connect To Service" })
    vim.keymap.set("n", "<leader>cj", ":ConjureConnect local.aclaimant.com 7001<cr>", { desc = "Connect To Jobs" })
    vim.keymap.set("n", "<leader>ca", ":ConjureConnect local.aclaimant.com 7002<cr>", { desc = "Connect To Alerter" })
    -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
    --vim.g["conjure#debug"] = true
  end,
}
