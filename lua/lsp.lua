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
  virtual_lines = false,
  update_in_insert = false,
})

-- Lua LS
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        globals = { 'vim', 'require', 'print', 'pcall', 'pairs', 'ipairs' },
      },
      -- workspace.library is intentionally unset -- lazydev.nvim manages it
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
  flags = {
    allow_incremental_sync = false, -- send full doc, reduces race conditions
  },
})

vim.lsp.enable("clojure_lsp")

--Python
vim.lsp.config("basedpyright", {
  filetypes = { "python" },
  cmd = { "basedpyright-langserver", "--stdio" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "off",
        diagnosticSeverityOverrides = {
          reportUndefinedVariable = "error",
        },
      },
    },
  },
})

vim.lsp.enable("basedpyright")

--GO!
vim.lsp.config("gopls", {
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  cmd = { "gopls" },
  root_markers = { "go.mod", "go.work", ".git" },
})

vim.lsp.enable("gopls")

-- JavaScript / TypeScript
vim.lsp.config("ts_ls", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})

vim.lsp.enable("ts_ls")

-- C / C++
vim.lsp.config("clangd", {
  filetypes = { "c", "cpp", "objc", "objcpp" },
  cmd = { "clangd" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.lsp.enable("clangd")

-- Jinja templates named .js
--
-- Some repos generate JavaScript from Jinja and keep the .js extension, e.g.
-- cube_cloud's generation/templates/*.js. Those files contain `{%- set ... %}`
-- and `{#- ... -#}` blocks, which are not JavaScript, so ts_ls reports a syntax
-- error on essentially every line and buries any real diagnostic.
--
-- Detach ts_ls from such buffers rather than changing filetype, so JavaScript
-- syntax highlighting and treesitter still work -- only the bogus diagnostics go.
-- Detection is by CONTENT, not path, so it covers any template anywhere.
local function looks_like_jinja(buf)
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, 80, false)) do
    if line:match("{%%%-?%s") or line:match("{#") then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= "ts_ls" then
      return
    end
    if not looks_like_jinja(event.buf) then
      return
    end
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(event.buf) then
        vim.lsp.buf_detach_client(event.buf, client.id)
        vim.diagnostic.reset(vim.lsp.diagnostic.get_namespace(client.id), event.buf)
      end
    end)
  end,
})
