return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = false,
      })
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
    opts = {
      ensure_installed = { "lua_ls", "clojure_lsp", "clangd", "jsonls", "ts_ls" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
