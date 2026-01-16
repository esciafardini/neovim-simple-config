local function is_dadbod_ui_buffer()
  local ft = vim.bo.filetype
  local bufname = vim.api.nvim_buf_get_name(0)
  print("ft:", ft, "name:", bufname)
end

return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion" },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  keys = {
    { "<leader>du", "<cmd>DBUIToggle<cr>",        desc = "Toggle DB UI" },
    { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
    { "<leader>df", "<cmd>DBUIFindBuffer<cr>",    desc = "Find DB buffer" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_save_location = '~/dev/aclaimant/acl/db_ui_queries'
    vim.g.db_ui_use_preview = 1
    vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        vim.bo.omnifunc = "vim_dadbod_completion#omni"
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*local-query*",
      callback = function()
        vim.defer_fn(function()
          if vim.bo.filetype == "sql" then
            local bufname = vim.api.nvim_buf_get_name(0)
            if bufname:match("aclaimant%-local%-query") and vim.fn.line2byte('$') == -1 then
              vim.api.nvim_put({ "set search_path to melco, common;" }, "c", false, false)
              vim.cmd("normal <Plug>(DBUI_ExecuteQuery)")
              print("search_path set to melco")
            end
          end
        end, 100)
      end,
    })
  end,
}
