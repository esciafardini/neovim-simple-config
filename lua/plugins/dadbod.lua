return {
  -- table/column completion for SQL buffers; connection is set by connect_to_psql in conjure.lua
  "kristijanhusak/vim-dadbod-completion",
  ft = "sql",
  dependencies = { "tpope/vim-dadbod" },
}
