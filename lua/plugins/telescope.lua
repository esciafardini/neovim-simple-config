return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope-fzf-native.nvim",
    "danielfalk/smart-open.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        selection_strategy = "row",
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "ignore_case",
        },
        smart_open = {
          match_algorithm = "fzf",
          show_scores = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("smart_open")
  end,
  keys = {
    {
      "<leader>ff",
      function()
        if vim.fn.getcwd() == vim.env.HOME then
          vim.notify("Not in ~, use a project directory", vim.log.levels.WARN)
          return
        end
        require("telescope").extensions.smart_open.smart_open()
      end,
      desc = "Find Files (Smart)",
    },
    { "<leader>fF",       "<cmd>Telescope find_files<cr>", desc = "Find Files (All)" },
    { "<leader>fw",       "<cmd>Telescope live_grep<cr>",  desc = "Find Word" },
    { "<leader>fb",       "<cmd>Telescope buffers<cr>",    desc = "Find Buffer" },
    { "<leader><leader>", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
  },
}
