return {
  "Olical/conjure",
  ft = { "clojure", "fennel", "python" },
  lazy = true,
  init = function()
    vim.g["conjure#log#filetype"] = "clojure"
    vim.g["conjure#extract#tree_sitter#enabled"] = true

    vim.keymap.set("n", "<leader>cS", function()
      local host, port = "127.0.0.1", 7888
      local tcp = vim.uv.new_tcp()

      if not tcp then
        vim.notify("Failed to create TCP socket", vim.log.levels.ERROR)
        return
      end

      tcp:connect(host, port, function(err)
        tcp:close()
        vim.schedule(function()
          if err then
            vim.notify("No Shadow CLJS running on port:" .. port .. ". Try running lein cooper", vim.log.levels.WARN)
          else
            vim.cmd("ConjureConnect " .. host .. " " .. port)
            vim.defer_fn(function()
              vim.cmd("ConjureShadowSelect app")
            end, 1000)
          end
        end)
      end)
    end, { desc = "Connect To Shadow CLJS App" })

    vim.keymap.set("n", "<leader>cs", ":ConjureConnect local.aclaimant.com 7000<cr>", { desc = "Connect To Service" })
    vim.keymap.set("n", "<leader>cj", ":ConjureConnect local.aclaimant.com 7001<cr>", { desc = "Connect To Jobs" })
    vim.keymap.set("n", "<leader>ca", ":ConjureConnect local.aclaimant.com 7002<cr>", { desc = "Connect To Alerter" })

    vim.g["conjure#mapping#doc_word"] = "k"
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
