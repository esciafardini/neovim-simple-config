return {
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
      --nnoremap <silent> <leader>gg :LazyGit<CR>
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension("lazygit")
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>")
    end,
  },
  { "tpope/vim-fugitive" },
}
