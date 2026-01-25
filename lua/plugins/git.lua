local function hunk_nav()
  vim.cmd("Gitsigns next_hunk")
end

local function cursor_in_hunk(lnum, hunk)
  if hunk.added.count > 0 then
    return lnum >= hunk.added.start and lnum <= hunk.added.start + hunk.added.count - 1
  else
    -- delete hunk: sign shows at added.start (line after deletion) check current line OR line before (where you might be positioned)
    return lnum == hunk.added.start or lnum == hunk.added.start - 1 or lnum == hunk.added.start + 1
  end
end

local function select_to_stage_or_unstage()
  local cache = require('gitsigns.cache').cache
  local gitsigns = require('gitsigns')

  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]

  local bcache = cache[bufnr]
  if not bcache then return end

  local unstaged_hunks = bcache.hunks or {}
  local staged_hunks = bcache.hunks_staged or {}
  local all_hunks = vim.tbl_extend("force", unstaged_hunks, staged_hunks)

  for _, hunk in ipairs(all_hunks) do
    if cursor_in_hunk(lnum, hunk) then
      gitsigns.stage_hunk()
      return
    end
  end

  vim.notify("No hunk at cursor position")
end

return {
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    "esciafardini/gitsigns.nvim",
    --dir = "/Users/remote-dev/Projects/gitsigns.nvim",
    -- ^ switch to this for dev
    event = "BufReadPre",
    config = function()
      local gitsigns = require("gitsigns")

      gitsigns.setup({
        on_attach = function(bufnr)
          local filepath = vim.api.nvim_buf_get_name(bufnr)
          if filepath:find(vim.fn.expand("~") .. "/obsidian", 1, true) then
            return false
          end
        end,
        signs = {
          add          = { text = "|" },
          change       = { text = "|" },
          delete       = { text = "✗" },
          topdelete    = { text = "✗" },
          changedelete = { text = "✗" },
        },
        signs_staged = {
          add          = { text = "✓" },
          change       = { text = "✓" },
          delete       = { text = "✗" },
          topdelete    = { text = "✗" },
          changedelete = { text = "✗" },
        },
      })

      -- Github colors for staged/unstaged
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#BD2C00" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#BD2C00" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#BD2C00" })
      vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { fg = "#2DBA4E" })
      vim.api.nvim_set_hl(0, "GitSignsStagedChange", { fg = "#2DBA4E" })
      vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { fg = "#2DBA4E" })

      -- Keymaps
      vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git Blame Line" })
      vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<cr>", { desc = "Git Blame Toggle" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Git Preview" })
      vim.keymap.set("n", "<leader>gn", hunk_nav, { desc = "Git Nav To Next Hunk" })
      vim.keymap.set("n", "<leader>gs", select_to_stage_or_unstage, { desc = "Git Stage/Unstage Hunk" })
      vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Git Reset Hunk" })
      vim.keymap.set("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Git Stage Buffer" })
      vim.keymap.set("n", "<leader>gR", "<cmd>Gitsigns reset_buffer_index<cr>", { desc = "Git Reset Buffer" })
      vim.keymap.set("n", "<leader>gf", "<cmd>Gitsigns refresh<cr>", { desc = "Git Refresh" })
    end,
  },
}
