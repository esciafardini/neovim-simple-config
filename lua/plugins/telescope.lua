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
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("smart_open")
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
  end,
  keys = {
    { "<leader>ff",       "<cmd>Telescope smart_open<cr>", desc = "Find Files (Smart)" },
    { "<leader>fF",       "<cmd>Telescope find_files<cr>", desc = "Find Files (All)" },
    { "<leader>fw",       "<cmd>Telescope live_grep<cr>",  desc = "Find Word" },
    { "<leader>fb",       "<cmd>Telescope buffers<cr>",    desc = "Find Buffer" },
    { "<leader><leader>", "<cmd>Telescope oldfiles<cr>",   desc = "Open Telescope" },
  },
}
