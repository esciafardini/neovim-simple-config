local vault = vim.fn.expand("~") .. "/obsidian"

return {
  "obsidian-nvim/obsidian.nvim",
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
  ft = "markdown",
  keys = {
    { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
    { "<leader>os", "<cmd>Obsidian search<cr>",       desc = "Search vault" },
    { "<leader>on", "<cmd>Obsidian new<cr>",          desc = "New note" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>",    desc = "Backlinks" },
    { "<leader>ot", "<cmd>Obsidian today<cr>",        desc = "Today's note" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>",    desc = "Yesterday's note" },
  },
  config = function()
    require("obsidian").setup({
      legacy_commands = false,
      workspaces = {
        {
          name = "obsidian",
          path = vault,
        },
      },
      completion = {
        min_chars = 2,
      },
      new_notes_location = "current_dir",
      frontmatter = {
        enabled = false,
      },
      note_id_func = function(title)
        if title ~= nil then
          return (title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""))
        else
          return tostring(os.time())
        end
      end,
      templates = {
        folder = vault .. "/templates",
      },
      daily_notes = {
        enabled = true,
        folder = "daily",
        template = "daily.md",
      },
      checkbox = {
        order = { " ", "x", "~", "!", ">" },
      },
      ui = {
        enabled = true,
        enable = true,
        ignore_conceal_warn = false,
        update_debounce = 200,
        max_file_length = 5000,
        checkbox = {
          enabled = true,
          create_new = true,
          order = { " ", "~", "!", ">", "x" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          ObsidianTodo = { fg = "#6b9a9e", bold = true },
          ObsidianDone = { fg = "#5e8e8b" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianImportant = { bold = true, fg = "#d73128" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },
    })
  end,
}
