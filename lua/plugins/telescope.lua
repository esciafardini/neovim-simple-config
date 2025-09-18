return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Find Word" })
      vim.keymap.set("n", "<leader>st", builtin.live_grep, { desc = "Search Text" })
      vim.keymap.set("n", "<leader>sf", builtin.live_grep, { desc = "Search File" })
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Open Telescope" })
      require("telescope").load_extension("ui-select")
    end,
  },
}
