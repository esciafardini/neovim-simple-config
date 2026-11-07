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

-- dadbod runs psql with --no-psqlrc, so put every non-system schema on its search_path
-- (public and common first) so app and tenant tables all complete, whatever they're named
local function completion_url(url)
  local schemas = vim.fn.systemlist({
    "psql", "-X", "-w", "-At", "--dbname", url, "-c",
    "select nspname from pg_namespace"
      .. " where nspname !~ '^pg_' and nspname <> 'information_schema'"
      .. " order by nspname <> 'public', nspname <> 'common', nspname",
  })
  if vim.v.shell_error ~= 0 or #schemas == 0 then
    return url
  end
  return url .. (url:find("?", 1, true) and "&" or "?")
    .. "options=-csearch_path%3D" .. table.concat(schemas, "%2C")
end

local function connect_to_psql(env_var)
  return function()
    local url = vim.env[env_var]
    if not url then
      vim.notify(env_var .. " is not set (restart nvim from a fresh shell?)", vim.log.levels.WARN)
      return
    end
    vim.g["conjure#client#sql#stdio#command"] = "psql " .. url
    -- point dadbod completion at the same DB and refresh its table/column cache
    local db_url = completion_url(url)
    vim.g.db = db_url
    vim.b.db = db_url
    pcall(vim.fn["vim_dadbod_completion#fetch"], vim.api.nvim_get_current_buf())
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
    { "<leader>cpl", connect_to_psql("LOCAL_DB_URL"), ft = "sql", desc = "SQL Local" },
    { "<leader>cps", connect_to_psql("STAGING_DB_URL"), ft = "sql", desc = "SQL Staging" },
    { "<leader>cpp", connect_to_psql("PROD_DB_URL"), ft = "sql", desc = "SQL Prod" },
    { "<leader>cpd", connect_to_psql("COIN_DB_URL"), ft = "sql", desc = "SQL Coin Dolphin (local)" },
    { "<leader>cpg", connect_to_psql("GRIDER_DB_URL"), ft = "sql", desc = "SQL Grider Tutorial (local)" },
    { "<leader>cpf", connect_to_psql("TAOP_F1DB_URL"), ft = "sql", desc = "SQL TAOP f1db (docker)" },
    { "<leader>cpc", connect_to_psql("TAOP_CDSTORE_URL"), ft = "sql", desc = "SQL TAOP cdstore (docker)" },
    { "<leader>cpt", connect_to_psql("TAOP_APPDEV_URL"), ft = "sql", desc = "SQL TAOP appdev (docker)" },
  },
}
