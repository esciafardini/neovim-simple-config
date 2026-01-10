return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope-fzf-native.nvim",
    "danielfalk/smart-open.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "danielfalk/smart-open.nvim",
  },
  config = function()
    require("telescope").setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "ignore_case",
        },
        smart_open = {
          match_algorithm = "fzf",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope smart_open<cr>", { desc = "Find Files (Smart)" })
    vim.keymap.set("n", "<leader>fF", builtin.find_files, { desc = "Find Files (All)" })
    vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Find Word" })
    vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Open Telescope" })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("smart_open")
  end,
}
