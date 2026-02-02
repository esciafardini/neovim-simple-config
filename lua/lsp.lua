-- LSP Settings
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

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = true,
  update_in_insert = false,
})

-- Lua LS
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath('data'),
        },
      },
    },
  },
})
vim.lsp.enable('lua_ls')

-- Ruby LSP
vim.lsp.config("ruby_lsp", {
  filetypes = { "ruby" },
  cmd = { "ruby-lsp" },
  root_markers = { "Gemfile", ".git" },
  init_options = {
    formatter = 'standard',
    linters = { 'standard' },
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
})
vim.lsp.enable("ruby_lsp")

-- Clojure LSP
vim.lsp.config("clojure_lsp", {
  filetypes = { "clojure" },
  cmd = { "clojure-lsp" },
  root_markers = { ".git", "deps.edn", "project.clj" },
  single_file_support = true,
  flags = {
    debounce_text_changes = 500,    -- 500ms debounce (was 15s - too long causes stale state)
    allow_incremental_sync = false, -- send full doc, reduces race conditions
  },
})
vim.lsp.enable("clojure_lsp")
