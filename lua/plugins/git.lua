local function hunk_nav()
  vim.notify("Nav'ing to next hunk")
  vim.cmd("Gitsigns next_hunk")
end

local function select_to_stage()
  vim.cmd("Gitsigns select_hunk")
  vim.cmd("Gitsigns stage_hunk")
  vim.notify("✓ Hunk has been staged ✓")
end

local function select_to_reset()
  vim.cmd("Gitsigns select_hunk")
  vim.cmd("Gitsigns stage_hunk")
  vim.notify("☻ Hunk has been reset ☻")
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
    keys = {
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git Blame Line" },
      { "<leader>gB", "<cmd>Gitsigns blame<cr>",                     desc = "Git Blame Toggle" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>",       desc = "Git Preview" },
      { "<leader>gn", hunk_nav,                                      desc = "Git Nav To Next Hunk" },
      { "<leader>gs", select_to_stage,                               desc = "Git Stage Hunk" },
      { "<leader>gr", select_to_reset,                               desc = "Git Reset Hunk" },
    },
  },
}
