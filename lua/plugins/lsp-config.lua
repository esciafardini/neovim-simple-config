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
          -- format current form
          vim.keymap.set("n", "<leader>lf", function()
            local node = vim.treesitter.get_node()
            local form_types = {
              -- handles common blocks in clojure, ruby, javascript (may need to add more later)
              "object", "arrow_function", "do_block", "function_expression", "hash", "method", "block",
              "function_declaration", "set_lit", "vec_lit", "function_definition", "table_constructor",
              "map_lit", "anon_fn_lit", "list_lit", "array", "body_statement"
            }
            while node do
              local node_type = node:type()
              for _, form_type in ipairs(form_types) do
                if node_type == form_type then
                  local start_row, start_col, end_row, end_col = node:range()
                  vim.lsp.buf.format({
                    range = {
                      ["start"] = { start_row + 1, start_col },
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
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      vim.lsp.config("ruby_lsp", {
        init_options = {
          formatter = "rubocop",
        },
      })
      vim.lsp.config("clojure_lsp", {
        flags = {
          debounce_text_changes = 1500, -- lsp was lagging on keypress - not anymore :)
        },
      })
    end,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
