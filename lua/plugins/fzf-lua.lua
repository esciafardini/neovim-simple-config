return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    fzf_opts = {
      ["--cycle"] = true,
    },
    keymap = {
      fzf = {
        ["ctrl-j"] = "down",
        ["ctrl-k"] = "up",
      },
    },
  },
  vim.keymap.set("n", "<leader>ff", ":FzfLua files<cr>", { desc = "Find files" }),
  vim.keymap.set("n", "<leader>fw", ":FzfLua live_grep<cr>", { desc = "Find words" }),
  vim.keymap.set("n", "<leader>ar", ":FzfLua oldfiles<cr>", { desc = "Old files" }),
  vim.keymap.set("n", "<leader>fb", ":FzfLua buffers<cr>", { desc = "Find buffers" })
}
