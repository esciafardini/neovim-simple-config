return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = false,
      })
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover({border = "single", width = 100})<cr>', { desc = "LSP Hover" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go To Definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go To Reference" })
      vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Actions" })
      vim.keymap.set({ "n" }, "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set({ "n" }, "<leader>lF", vim.lsp.buf.format, { desc = "Format File" })
      vim.keymap.set("n", "<leader>lf", function()
        local node = vim.treesitter.get_node()
        -- Clojure form types in treesitter
        local form_types = { "list_lit", "vec_lit", "map_lit", "set_lit", "anon_fn_lit" }
        while node do
          local node_type = node:type()
          for _, form_type in ipairs(form_types) do
            if node_type == form_type then
              local start_row, start_col, end_row, end_col = node:range()
              vim.lsp.buf.format({
                range = {
                  start = { start_row + 1, start_col },
                  ["end"] = { end_row + 1, end_col },
                }
              })
              return
            end
          end
          node = node:parent()
        end
        print("No form found")
      end, { desc = "Format form" })

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
      ensure_installed = { "clojure_lsp", "lua_ls", "clangd", "jsonls", "ts_ls" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
