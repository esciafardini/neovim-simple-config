return {
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension("lazygit")
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Lazy Git!" })
    end,
  },
  { "tpope/vim-fugitive" },
}
