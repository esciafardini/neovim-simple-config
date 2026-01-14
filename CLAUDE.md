# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular Neovim configuration optimized for Clojure development with REPL-driven workflows. Uses lazy.nvim for plugin management with auto-discovery of plugin specs in `lua/plugins/`.

## Architecture

```
init.lua                 # Entry point: loads options.lua then lazyconfig.lua
lua/
  options.lua            # Global settings, keymaps, autocmds, leader keys
  lazyconfig.lua         # lazy.nvim bootstrap and plugin loader
  plugins/               # Auto-loaded plugin configurations (one per file)
snippets/                # Custom VSCode-format snippets for LuaSnip
```

## Key Conventions

- **Leader**: `<space>` (global), `,` (localleader for Clojure/Conjure)
- **LSP**: Managed via Mason + mason-lspconfig. Servers: clojure_lsp, lua_ls, ruby_lsp
- **Completion**: blink.cmp with LuaSnip snippets
- **Neovim version**: 0.11+ (uses modern `vim.lsp.config` API)

## Plugin Configuration Pattern

Each file in `lua/plugins/` returns a lazy.nvim spec table. Example structure:
```lua
return {
  "author/plugin-name",
  dependencies = { ... },
  config = function()
    -- setup code
  end,
}
```

## Important Keybinding Groups

| Prefix | Purpose | Config Location |
|--------|---------|-----------------|
| `<leader>f` | Telescope (find files/words) | `plugins/telescope.lua` |
| `<leader>l` | LSP actions | `plugins/lsp.lua` |
| `<leader>c` | Conjure REPL | `plugins/conjure.lua` |
| `<leader>s` | Treesitter selection | `plugins/treesitter.lua` |
| `<leader>g` | Git (lazygit, blame) | `plugins/git.lua` |
| `<localleader>` | Paredit/structural editing | `plugins/paredit.lua` |

## Clojure-Specific Features

- **Conjure ports**: Service (7000), Jobs (7001), Alerter (7002), Shadow CLJS (7888)
- **Log management**: `<leader>ls` wraps in `log/spy`, `<leader>ld` wraps in `log/daff`
- **Auto-cleanup**: Prompts to remove log statements on quit (clojure buffers)
- **Form formatting**: `<leader>lf` formats current s-expression using LSP
- **Paredit**: Structural editing with `<localleader>w`, `<localleader>[`, etc.

## Validation

Run `:checkhealth` to verify configuration health. All providers except Neovim core are disabled for performance.

## Internals Reference

### LSP Architecture

```
vim.lsp (built-in)        nvim-lspconfig (plugin)       mason.nvim (plugin)
─────────────────         ────────────────────          ─────────────────
LSP client that           Library of server configs     Package manager that
speaks the protocol       (how to start clojure_lsp,    downloads LSP servers
                          what args, root detection)    to ~/.local/share/nvim/mason/
        ↑                         ↑                              ↑
        └─────────────────────────┼──────────────────────────────┘
                                  │
                        mason-lspconfig (plugin)
                        ────────────────────────
                        Bridge: combines mason's binary paths
                        with lspconfig's server configs,
                        auto-starts servers for filetypes
```

### Completion Stack

```
┌─────────────────────────────────────────────┐
│  blink.cmp (UI)                             │
│  - Popup menu, keymaps, source aggregation  │
└─────────────────────────────────────────────┘
        │ gathers from sources:
        ▼
┌─────────────────────────────────────────────┐
│  Sources                                    │
│  - lsp      → language server completions   │
│  - buffer   → words in current file         │
│  - path     → filesystem paths              │
│  - snippets → from LuaSnip                  │
│  - lazydev  → Neovim Lua API (vim.*)        │
└─────────────────────────────────────────────┘
        │ snippets come from:
        ▼
┌─────────────────────────────────────────────┐
│  LuaSnip (engine)                           │
│  - Expands snippets, handles placeholders   │
│  - Loads from friendly-snippets + snippets/ │
└─────────────────────────────────────────────┘
```

### Treesitter Queries

Used in `conjure.lua` for log/spy and log/daff detection.

```lua
local query = ts.query.parse("clojure", [[
  (list_lit
    (sym_lit) @fn_name
    (_) @inner
    (#eq? @fn_name "log/spy"))
]])
```

- `ts.query.parse()` → compiles a tree pattern matcher
- `@name` → captures matching nodes, assigned integer IDs
- `(#eq? ...)` → predicate filter (only match if condition true)
- `query.captures` → lookup table `{1: "fn_name", 2: "inner"}`
- `query:iter_captures(root, bufnr)` → yields `(id, node)` pairs

```lua
for id, node in query:iter_captures(root, bufnr) do
  local name = query.captures[id]  -- integer → name
  if name == "inner" then
    local row, col = node:start()
    -- do something with position
  end
end
```
