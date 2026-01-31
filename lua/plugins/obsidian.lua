return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    local function is_obsidian_file()
      return vim.fn.expand("%:p"):find(vim.fn.expand("~") .. "/obsidian", 1, true)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        if is_obsidian_file() then
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nv"
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          vim.opt_local.foldmethod = "indent"
          vim.opt_local.foldlevel = 0
          vim.opt_local.foldtext = "(v:foldend - v:foldstart + 1) .. ' lines'"
        end
      end,
    })
  end,
  -- Only load for markdown files inside your vault
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/obsidian/**.md",
  },
  keys = {
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>",      desc = "Search vault" },
    { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "New note" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>",   desc = "Backlinks" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>",       desc = "Today's note" },
    { "<leader>oy", "<cmd>ObsidianToday -1<cr>",    desc = "Yesterday's note" } },
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
      -- Use title as filename instead of timestamp
      note_id_func = function(title)
        if title ~= nil then
          -- Slugify: lowercase, spaces to dashes, remove special chars
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- Fallback if no title given
          return tostring(os.time())
        end
      end,
      -- Templates
      templates = {
        folder = vault .. "/templates",
      },
      -- Daily notes
      daily_notes = {
        folder = "daily",
        template = "daily.md",
      },
      -- Open URLs in browser
      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url })
      end,
      -- UI: only checked and unchecked (nerd font)
      ui = {
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "󰄲", hl_group = "ObsidianDone" },
        },
      },
    }
  end,
}
