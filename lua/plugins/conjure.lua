local function connect_to_shadow_app()
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
end

local function connect_to_psql(url)
  return function()
    vim.g["conjure#client#sql#stdio#command"] = "psql " .. url
    vim.cmd("ConjureSqlStop")
    vim.defer_fn(function()
      vim.cmd("ConjureSqlStart")
    end, 500)
  end
end

return {
  "Olical/conjure",
  ft = { "clojure", "fennel", "python", "lua", "sql" },
  init = function()
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
    vim.g["conjure#extract#tree_sitter#enabled"] = true
    vim.g["conjure#mapping#doc_word"] = "k" -- registers as <localleader>k
    vim.g["conjure#log#filetype"] = "clojure"
    vim.g["conjure#filetypes"] = { "clojure", "fennel", "python", "lua", "sql" }
  end,
  keys = {
    -- Clojure
    { "<leader>cs",  ":ConjureConnect local.aclaimant.com 7000<cr>", ft = "clojure", desc = "Connect To Service" },
    { "<leader>cj",  ":ConjureConnect local.aclaimant.com 7001<cr>", ft = "clojure", desc = "Connect To Jobs" },
    { "<leader>ca",  ":ConjureConnect local.aclaimant.com 7002<cr>", ft = "clojure", desc = "Connect To Alerter" },
    { "<leader>cS",  connect_to_shadow_app, ft = "clojure", desc = "Connect To Shadow CLJS App" },
    -- SQL
    { "<leader>cpl", connect_to_psql(vim.env.LOCAL_DB_URL), ft = "sql", desc = "SQL Local" },
    { "<leader>cps", connect_to_psql(vim.env.STAGING_DB_URL), ft = "sql", desc = "SQL Staging" },
    { "<leader>cpp", connect_to_psql(vim.env.PROD_DB_URL), ft = "sql", desc = "SQL Prod" },
    { "<leader>cpd", connect_to_psql(vim.env.COIN_DB_URL), ft = "sql", desc = "SQL Coin Dolphin (local)" },
    { "<leader>cpg", connect_to_psql(vim.env.GRIDER_DB_URL), ft = "sql", desc = "SQL Grider Tutorial (local)" },
    { "<leader>cpa", connect_to_psql(vim.env.F1DB_URL), ft = "sql", desc = "SQL Art Of Postgres" },
  },
}
