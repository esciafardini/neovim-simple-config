return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[▐ ▄ ▄▄▄ .       ▌ ▐·▪  • ▌ ▄ ·. ]],
        [[•█▌▐█▀▄.▀·▪     ▪█·█▌██ ·██ ▐███▪]],
        [[▐█▐▐▌▐▀▀▪▄ ▄█▀▄ ▐█▐█•▐█·▐█ ▌▐▌▐█·]],
        [[██▐█▌▐█▄▄▌▐█▌.▐▌ ███ ▐█▌██ ██▌▐█▌]],
        [[▀▀ █▪ ▀▀▀  ▀█▄▀▪. ▀  ▀▀▀▀▀  █▪▀▀▀]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
        dashboard.button("n", "  New File", ":ene | startinsert<CR>"),
        dashboard.button("w", "  Find Text", ":Telescope live_grep<CR>"),
        dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("c", "  Config", ":Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>"),
        dashboard.button("l", "  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Center the dashboard vertically
      local content_height = #dashboard.section.header.val + #dashboard.section.buttons.val + 4
      local padding = math.max(0, math.floor((vim.fn.winheight(0) - content_height) / 2))
      dashboard.config.layout = {
        { type = "padding", val = padding },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
      }

      alpha.setup(dashboard.config)

      vim.keymap.set("n", "<leader>a", ":Alpha<CR>", { desc = "Dashboard", silent = true })
    end,
  },
  {
    "LunarVim/bigfile.nvim",
    event = "BufReadPre",
    opts = {},
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
