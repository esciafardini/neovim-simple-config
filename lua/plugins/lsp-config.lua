return {
  {
    "neovim/nvim-lspconfig",
    config = function()

      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = true ,
        virtual_lines = false,
      })

      -- Keymaps
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover({border = "single", width = 100})<cr>')
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
      vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, {})
      vim.keymap.set({ "n" }, "<leader>lr", vim.lsp.buf.rename, {})
      vim.keymap.set({ "n" }, "<leader>lf", vim.lsp.buf.format, {})
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim",  opts = {} },
      { "neovim/nvim-lspconfig", opts = {} },
    },
  },
}
