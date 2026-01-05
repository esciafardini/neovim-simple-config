return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = false,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = function(desc)
            return { buffer = event.buf, desc = desc }
          end

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover({border = "single", width = 100})<cr>', opts("LSP Hover"))
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go To Definition"))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Go To Reference"))
          vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts("Code Actions"))
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts("Rename"))
          vim.keymap.set("n", "<leader>lF", vim.lsp.buf.format, opts("Format File"))
          vim.keymap.set("n", "<leader>lf", function()
            local node = vim.treesitter.get_node()
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
          end, opts("Format form"))
        end,
      })
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
      ensure_installed = { "clojure_lsp", "lua_ls", "clangd", "jsonls", "ts_ls", "ruby_lsp" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
