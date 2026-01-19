local function hunk_nav()
  vim.notify("Nav'ing to next hunk")
  vim.cmd("Gitsigns next_hunk")
end

local function select_to_stage()
  vim.cmd("Gitsigns select_hunk")
  vim.cmd("Gitsigns stage_hunk")
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
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git Blame Line" },
      { "<leader>gB", "<cmd>Gitsigns blame<cr>",                     desc = "Git Blame Toggle" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>",       desc = "Git Preview" },
      { "<leader>gn", hunk_nav,                                      desc = "Git Nav To Next Hunk" },
      { "<leader>gs", select_to_stage,                               desc = "Git Stage/Reset Hunk" },
      { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>",              desc = "Git Stage Buffer" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer_index<cr>",        desc = "Git Reset Buffer" },
    },
    config = function()
      require("gitsigns").setup({
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
  },
}
