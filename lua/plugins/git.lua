local function hunk_nav()
  vim.notify("Nav'ing to next hunk")
  vim.cmd("Gitsigns next_hunk")
end

local function select_to_stage_or_unstage()
  local cache = require('gitsigns.cache').cache

  -- where am I?
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] -- current lnum (yes, good.)

  -- hunks!
  local unstaged_hunks = cache[bufnr].hunks or {}
  local staged_hunks = cache[bufnr].hunks_staged or {}

  for _, hunk in ipairs(unstaged_hunks) do
    if lnum >= hunk.added.start and lnum < hunk.added.start + hunk.added.count then
      vim.cmd("Gitsigns select_hunk")
      vim.cmd("Gitsigns stage_hunk")
      return
    end
  end

  for _, hunk in ipairs(staged_hunks) do
    if lnum >= hunk.added.start and lnum < hunk.added.start + hunk.added.count then
      vim.cmd("Gitsigns select_hunk")
      vim.cmd("Gitsigns undo_stage_hunk")
      return
    end
  end

  vim.notify("there's no hunk here!!")
end

return {
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    dir = "~/projects/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      local gitsigns = require("gitsigns")

      gitsigns.setup({
        signs = {
          add          = { text = "◇" },
          change       = { text = "○" },
          delete       = { text = "✗" },
          topdelete    = { text = "✗" },
          changedelete = { text = "?" },
        },
        signs_staged = {
          add          = { text = "◆" },
          change       = { text = "●" },
          delete       = { text = "✓" },
          topdelete    = { text = "✓" },
          changedelete = { text = "✓" },
        },
      })

      -- Kanagawa orange for unstaged (surimiOrange)
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#FFA066" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#FFA066" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#FFA066" })

      -- Kanagawa blue for staged (springBlue)
      vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { fg = "#7FB4CA" })
      vim.api.nvim_set_hl(0, "GitSignsStagedChange", { fg = "#7FB4CA" })
      vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { fg = "#7FB4CA" })
    end,
    keys = {
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git Blame Line" },
      { "<leader>gB", "<cmd>Gitsigns blame<cr>",                     desc = "Git Blame Toggle" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>",       desc = "Git Preview" },
      { "<leader>gn", hunk_nav,                                      desc = "Git Nav To Next Hunk" },
      { "<leader>gs", select_to_stage_or_unstage,                    desc = "Git Stage/Unstage Hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",                desc = "Git Reset Hunk" },
      { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>",              desc = "Git Stage Buffer" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer_index<cr>",        desc = "Git Reset Buffer" },
    },
  },
}
