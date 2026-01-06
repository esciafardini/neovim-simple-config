# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using lazy.nvim for plugin management. The config is Clojure-focused with REPL-driven development support via Conjure.

**Neovim Version**: 0.11+ (uses `vim.lsp.config` API, not deprecated `require('lspconfig')`)

## Architecture

**Entry Point**: `init.lua` requires two modules:
- `options` - Core settings, keymaps, autocmds
- `lazyconfig` - lazy.nvim bootstrap and plugin loading

**Plugin Specs**: Each file in `lua/plugins/` returns a lazy.nvim plugin spec table. Lazy.nvim auto-discovers and loads all files in this directory.

**Snippets**: Custom VSCode-format snippets in `snippets/` directory, loaded by LuaSnip.

## Adding Plugins

Create a new file in `lua/plugins/` returning a spec:

```lua
return {
  "author/plugin-name",
  lazy = true,                          -- or use ft/cmd/keys/event for triggers
  dependencies = { "dep1" },
  config = function()
    require("plugin").setup({ ... })
  end,
}
```

## Keymap Conventions

- **Leader**: Space
- **Local Leader**: Comma (used for Lisp/Conjure operations)
- **Prefix Groups** (defined in which-key):
  - `<leader>c` - Conjure REPL
  - `<leader>l` - LSP operations
  - `<leader>s` - Treesitter selections
  - `<leader>g` - Git

## LSP Setup

Mason ensures these servers are installed: `lua_ls`, `clojure_lsp`, `clangd`, `jsonls`, `ts_ls`, `ruby_lsp`

LSP keymaps are attached on `LspAttach` event in `lsp-config.lua`. Use `vim.lsp.config()` for server-specific settings (not `require('lspconfig')`).

## Clojure-Specific

- Conjure connects to local services on ports 7000, 7001, 7002 via `<leader>cs/cj/ca`
- Custom fuzzy indentation for routing macros (GET, POST, PUT, etc.) in `options.lua`
- Paredit provides structural editing (slurp/barf/raise/splice)
- Custom snippets include `spy`, `tx`, `px`, `cx` templates

## Testing Changes

After modifying configs, restart Neovim or run `:Lazy reload <plugin>`. Use `:checkhealth` to diagnose issues.
