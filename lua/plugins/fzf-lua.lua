return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  vim.keymap.set("n", "<leader>ff", ":FzfLua files<cr>", { desc = "Find files" }),
  vim.keymap.set("n", "<leader>fw", ":FzfLua live_grep<cr>", { desc = "Find words" }),
  vim.keymap.set("n", "<leader>fb", ":FzfLua buffers<cr>", { desc = "Find buffers" })
}
