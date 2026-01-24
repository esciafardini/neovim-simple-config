return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- Only load for markdown files inside your vault
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/obsidian/**.md",
  },
  -- Also load when these commands are invoked
  cmd = { "ObsidianToday", "ObsidianNew", "ObsidianQuickSwitch", "ObsidianSearch" },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        if vim.fn.expand("%:p"):find(vim.fn.expand("~") .. "/obsidian", 1, true) then
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nvc"
          vim.opt_local.foldmethod = "indent"
          vim.opt_local.foldlevel = 0
          vim.opt_local.foldtext = "(v:foldend - v:foldstart + 1) .. ' lines'"
        end
      end,
    })
  end,
  opts = function()
    local vault = vim.fn.expand("~") .. "/obsidian"
    return {
      workspaces = {
        {
          name = "obsidian",
          path = vault,
        },
      },
      -- Disable completion source to avoid slowdown
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },
      -- Optional: customize how links/notes work
      notes_subdir = nil,
      new_notes_location = "current_dir",
      -- Don't add frontmatter automatically
      disable_frontmatter = true,
      -- Templates
      templates = {
        folder = vault .. "/templates",
      },
      -- Daily notes
      daily_notes = {
        folder = "daily",
        template = "daily.md",
      },
      -- UI: only checked and unchecked (nerd font)
      ui = {
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "󰄲", hl_group = "ObsidianDone" },
        },
      },
    }
  end,
  keys = {
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search vault" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
  },
}
