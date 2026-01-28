return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
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

    vim.lsp.config("ruby_lsp", {
      init_options = {
        formatter = "rubocop",
      },
    })
    vim.lsp.config("clojure_lsp", {
      single_file_support = true,
      flags = {
        debounce_text_changes = 15000,
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

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local opts = function(desc)
          return { buffer = event.buf, desc = desc }
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go To Definition"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Go To Reference"))
        vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts("Code Actions"))
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts("Rename"))

        -- format file
        vim.keymap.set("n", "<leader>lF", function()
          vim.lsp.buf.format()
          vim.notify("File formatted")
        end, opts("Format File"))

        -- format current form
        vim.keymap.set("n", "<leader>lf", function()
          local node = vim.treesitter.get_node()
          local form_types = {
            "list_lit", "block", "table_constructor", "function_definition"
          }
          while node do
            local node_type = node:type()
            for _, form_type in ipairs(form_types) do
              if node_type == form_type then
                local start_row, start_col, end_row, end_col = node:range()
                vim.lsp.buf.format({
                  range = { -- row (line numbers) are index 1
                    ["start"] = { start_row + 1, start_col },
                    ["end"] = { end_row + 1, end_col }
                  }
                })
                return
              end
            end
            node = node:parent()
          end
          vim.notify("No form found, formatting file")
          vim.lsp.buf.format()
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
