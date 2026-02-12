return {
  "saghen/blink.cmp", -- the UI pop-up and shortcut provider
  dependencies = {
    {
      "folke/lazydev.nvim",
      lazy = false, -- ensure this is loaded to suppress "vim as global" and other irritations
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "L3MON4D3/LuaSnip",
      -- a snippet engine
      -- expands the snippets
      dependencies = { "rafamadriz/friendly-snippets" },
      version = "v2.*",
      build = "make install_jsregexp",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
      end,
    }
  },
  version = "1.*",
  opts = {
    snippets = { preset = "luasnip" }, --use luasnip as snippet engine
    signature = { enabled = true }, --function signature help
    keymap = {
      preset = "default",
      ["<C-k>"] = { "fallback" }, -- keep digraphs around
      -- match behavior of command mode:
      ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
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
        show_on_trigger_character = true,
      },
    },
    sources = {
      -- default sources for blink
      default = { "buffer", "lsp", "path", "snippets", "lazydev" },
      -- overrides for sources for filetypes
      providers = {
        -- these providers don't work out of the box -- must specify
        lsp = {
          min_keyword_length = 3,  -- don't trigger LSP completion on short strings
        },
        lazydev = {
          name = "Neovim Lua",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  -- don't overwrite sources, merge instead (just in case)
  opts_extend = { "sources.default" }
}
