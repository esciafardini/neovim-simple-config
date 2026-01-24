return {
  -- completion UI (the popup menu, sources, keymaps)
  "saghen/blink.cmp",
  dependencies = {
    { -- Neovim Lua API completions (for vim.api.* suggestions)
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    { -- LuaSnip = snippet engine (expands snippets)
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
      version = "v2.*",
      build = "make install_jsregexp",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
      end,
    },
  },
  version = "1.*",
  opts = {
    snippets = { preset = "luasnip" },
    signature = { enabled = true },
    keymap = {
      preset = "default",
      ["<C-k>"] = { "fallback" },
      ["<Tab>"] = { "snippet_forward", "accept", "fallback" },
      ["<C-b>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono"
    },
    completion = {
      documentation = {
        auto_show = false
      },
      trigger = {
        show_on_keyword = false,
        show_on_trigger_character = false,
      },
    },
    sources = {
      default = { "buffer", "lazydev", "lsp", "path", "snippets" },
      per_filetype = {
        sql = { "dadbod", "buffer" },
        mysql = { "dadbod", "buffer" },
        plsql = { "dadbod", "buffer" },
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        dadbod = {
          name = "Dadbod",
          module = "vim_dadbod_completion.blink",
          score_offset = 100,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
