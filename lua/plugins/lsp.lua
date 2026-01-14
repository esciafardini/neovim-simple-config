return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    -- :Mason -> UI to browse, install, update packages
    "mason-org/mason-lspconfig.nvim",
    -- ensure_installed: declarative list, auto-installs on startup
    -- Auto-starts servers when you open matching filetypes
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "clojure_lsp", "lua_ls", "ruby_lsp" }
    })
    vim.diagnostic.config({
      virtual_text = true,
      virtual_lines = false,
    })
    -- Server configs
    vim.lsp.config("ruby_lsp", {
      init_options = {
        formatter = "rubocop",
      },
    })
    vim.lsp.config("clojure_lsp", {
      flags = {
        debounce_text_changes = 1500,
      },
    })
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "pcall", "vim", "require", "print" } },
        },
      },
    })
    -- Keymaps (on attach)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local opts = function(desc)
          return { buffer = event.buf, desc = desc }
        end
        -- some of these are default, but I keep them here for reference
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
            "list_lit", "block", "table_constructor"
          }
          while node do
            local node_type = node:type()
            for _, form_type in ipairs(form_types) do
              if node_type == form_type then
                local start_row, start_col, end_row, end_col = node:range()
                vim.lsp.buf.format({
                  range = {
                    ["start"] = { start_row + 1, start_col },
                    ["end"] = { end_row + 1, end_col }
                  }
                })
                return
              end
            end
            node = node:parent()
          end
          print("No form found")
        end, opts("Format form"))
        -- clean up un-used (pcall to ignore if not set - OCD desire for :checkhealth to have no warnings)
        pcall(vim.keymap.del, "n", "grt")
        pcall(vim.keymap.del, "n", "grr")
        pcall(vim.keymap.del, "n", "gra")
        pcall(vim.keymap.del, "n", "grn")
        pcall(vim.keymap.del, "n", "gri")
      end
    })
  end
}
