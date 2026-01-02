return {
  "Olical/conjure",
  ft = { "clojure", "fennel", "python" },
  lazy = true,
  init = function()
    vim.g["conjure#mapping#doc_word"] = "gk"
    vim.g["conjure#extract#tree_sitter#enabled"] = true
    vim.keymap.set("n", "<leader>cs", ":ConjureConnect local.aclaimant.com 7000<cr>", { desc = "Connect To Service" })
    vim.keymap.set("n", "<leader>cj", ":ConjureConnect local.aclaimant.com 7001<cr>", { desc = "Connect To Jobs" })
    vim.keymap.set("n", "<leader>ca", ":ConjureConnect local.aclaimant.com 7002<cr>", { desc = "Connect To Alerter" })
  end,
  config = function()
    vim.defer_fn(function()
      local filepath = vim.fn.expand("%:p")
      local target = vim.fn.expand("~/dev/aclaimant/acl")
      if filepath:find(target, 1, true) == 1 then
        vim.cmd("ConjureConnect local.aclaimant.com 7000")
      end
    end, 100)
  end,
}
