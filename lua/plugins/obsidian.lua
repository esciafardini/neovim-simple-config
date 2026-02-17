return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    local function is_obsidian_file()
      return vim.fn.expand("%:p"):find(vim.fn.expand("~") .. "/obsidian", 1, true)
    end

    -- Yank visual selection as displayed (with conceal chars)
    local function yank_as_displayed()
      local start_line = vim.fn.line("'<")
      local end_line = vim.fn.line("'>")
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

      for i, line in ipairs(lines) do
        lines[i] = line
          :gsub("^%s*%- %[ %]%s*", "󰄱 ")
          :gsub("^%s*%- %[x%]%s*", "󰄲 ")
          :gsub("^%s*%- %[X%]%s*", "✅ ")
          :gsub("^%s*%- %[Z%]%s*", "❌ ")
      end

      vim.fn.setreg("+", table.concat(lines, "\n"))
      vim.notify("Yanked " .. #lines .. " lines (as displayed)", vim.log.levels.INFO)
    end

    vim.keymap.set("v", "<leader>yo", function()
      -- Exit visual mode first to set '< and '> marks
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
      vim.api.nvim_feedkeys(esc, "x", false)
      vim.schedule(yank_as_displayed)
    end, { desc = "Yank as displayed (obsidian)" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        if is_obsidian_file() then
          vim.opt_local.conceallevel = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          vim.opt_local.foldmethod = "indent"
          -- Fold on # too
          vim.opt_local.foldignore = ""
          -- don't conceal in INSERT mode:
          vim.opt_local.concealcursor = "nv"
          -- just show "6 lines..." instead of preview:
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
          ["X"] = { char = "✅", hl_group = "ObsidianDone" },
          ["Z"] = { char = "❌", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
        hl_groups = {
          ObsidianTodo = { fg = "#6b9a9e", bold = true },
          ObsidianDone = { fg = "#5e8e8b" },
        },
      },
    }
  end,
}
