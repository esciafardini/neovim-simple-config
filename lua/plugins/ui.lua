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
        dashboard.button("f", "󰈞  Find File", ":Telescope smart_open<CR>"),
        dashboard.button("n", "󰈔  New File", ":ene | startinsert<CR>"),
        dashboard.button("w", "󰊄  Find Text", ":Telescope live_grep<CR>"),
        dashboard.button("r", "󰄉  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("c", "󰒓  Config", ":Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "󰩈  Quit", ":qa<CR>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.cursor = 0
      end

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

      -- Fast-blinking cursor on dashboard
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function()
          local old_guicursor = vim.o.guicursor

          -- Kanagawa springGreen
          vim.api.nvim_set_hl(0, "DashboardCursor", { fg = "#98BB6C", bg = "#98BB6C" })
          vim.opt.guicursor = "a:DashboardCursor/DashboardCursor-blinkwait10-blinkoff30-blinkon30"

          vim.api.nvim_create_autocmd("BufLeave", {
            buffer = 0,
            once = true,
            callback = function()
              vim.opt.guicursor = old_guicursor
            end,
          })
        end,
      })

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
