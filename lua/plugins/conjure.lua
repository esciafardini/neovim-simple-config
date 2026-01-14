return {
  "Olical/conjure",
  ft = { "clojure", "fennel", "python" },
  lazy = true,
  -- init happens BEFORE load
  init = function()
    -- vim.g loads before plugins, so need be set ahead of time
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
    vim.g["conjure#extract#tree_sitter#enabled"] = true
    vim.g["conjure#mapping#doc_word"] = "k" -- registers as <localleader>k
    vim.g["conjure#log#filetype"] = "clojure"
  end,
  config = function()
    vim.keymap.set("n", "<leader>cs", ":ConjureConnect local.aclaimant.com 7000<cr>", { desc = "Connect To Service" })
    vim.keymap.set("n", "<leader>cj", ":ConjureConnect local.aclaimant.com 7001<cr>", { desc = "Connect To Jobs" })
    vim.keymap.set("n", "<leader>ca", ":ConjureConnect local.aclaimant.com 7002<cr>", { desc = "Connect To Alerter" })
    vim.keymap.set("n", "<leader>cS", function()
      local tcp = vim.uv.new_tcp()
      if not tcp then
        vim.notify("Failed to create TCP socket", vim.log.levels.ERROR)
        return
      end
      tcp:connect("127.0.0.1", 7888,
        function(err)
          tcp:close()
          vim.schedule(function()
            if err then
              vim.notify("No Shadow CLJS running on port 7888. Try running lein cooper", vim.log.levels.WARN)
            else
              vim.cmd("ConjureConnect 127.0.0.1 7888")
              vim.defer_fn(function()
                vim.cmd("ConjureShadowSelect app")
              end, 1000)
            end
          end)
        end)
    end, { desc = "Connect To Shadow CLJS App" })
  end
}
