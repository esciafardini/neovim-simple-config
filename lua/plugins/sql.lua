 --  In vim-dadbod-ui, you can navigate away from the sidebar while preserving its state using standard Vim window navigation:
 --
 --  - <C-w>l or <C-w>w - move to the next window (your query buffer or results)
 --  - <C-w>h - move back to the sidebar
 --  - :DBUIToggle - hides the sidebar but preserves state; run again to restore it
 --
 --  The sidebar state persists as long as you don't quit Vim entirely. If you want to work in other buffers:
 --
 --  1. Use <C-w>l to leave the sidebar
 --  2. Open/edit other files normally
 --  3. Run :DBUIToggle or <C-w>h to return
 --
 --  If you're losing state, check if you have let g:db_ui_save_location set in your config - this persists connections across sessions.

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
  init = function()
    vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle DB UI" })
    vim.keymap.set("n", "<leader>da", "<cmd>DBUIAddConnection<cr>", { desc = "Add DB connection" })
    vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", { desc = "Find DB buffer" })
    vim.keymap.set({ "n", "v" }, "<leader>dr", "<cmd>DBUI_ExecuteQuery<cr>", { desc = "Run query" })
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_preview = 1
    vim.g.db_ui_save_location = "/Users/remote-dev/.local/share/nvim" .. "/db_ui"
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*local-query*",
      callback = function()
        vim.defer_fn(function()
          if vim.bo.filetype == "sql" then
            local bufname = vim.api.nvim_buf_get_name(0)
            if bufname:match("aclaimant%-local%-query") and vim.fn.line2byte('$') == -1 then
              vim.api.nvim_put({ "set search_path to common, ;" }, "c", false, false)
              vim.cmd('startinsert')
            end
          end
        end, 100)
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dbui",
      callback = function()
        vim.defer_fn(function()
          vim.cmd("normal! 2j")
        end, 100)
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dbout",
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "sql",
      callback = function()
        vim.keymap.set({ "n", "v" }, "<localleader>er", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Run query" })
      end,
    })
  end,
}
