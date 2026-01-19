local lisp_fts = { clojure = true, fennel = true, scheme = true, lisp = true }

-- Surround treesitter node under cursor with open/close chars
local function surround_node(open, close)
  if lisp_fts[vim.bo.filetype] then return end
  local node = vim.treesitter.get_node()
  if not node then return end
  local sr, sc, er, ec = node:range()
  -- Insert close first (so start position doesn't shift)
  vim.api.nvim_buf_set_text(0, er, ec, er, ec, { close })
  vim.api.nvim_buf_set_text(0, sr, sc, sr, sc, { open })
  vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
end

return {
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    require('mini.surround').setup({
      mappings = {
        add = 'sa',
        delete = 'ds',
        replace = 'cs',
        find = '',           -- disable sf
        find_left = '',      -- disable sF
        highlight = '',      -- disable sh
        update_n_lines = '', -- disable sn
        suffix_last = '',    -- disable 'l' suffix (dsl, csl, etc.)
        suffix_next = '',    -- disable 'n' suffix (dsn, csn, etc.)
      },
    })
  end,
  keys = {
    { 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], mode = 'x', silent = true },
    { ",'", "saiw'", remap = true, desc = "Surround word with '" },
    { ',"', 'saiw"', remap = true, desc = 'Surround word with "' },
    { ",`", "saiw`", remap = true, desc = "Surround word with `" },
    { ",s'", "sais'", remap = true, desc = "Surround sentence with '" },
    { ',s"', 'sais"', remap = true, desc = 'Surround sentence with "' },
    { ",s`", "sais`", remap = true, desc = "Surround sentence with `" },
    -- "good enough" wrapping of elements in non-clj files
    { "<localleader>w", function() surround_node("(", ")") end, desc = "Surround node with ()" },
    { "<localleader>(", function() surround_node("(", ")") end, desc = "Surround node with ()" },
    { "<localleader>[", function() surround_node("[", "]") end, desc = "Surround node with []" },
    { "<localleader>{", function() surround_node("{", "}") end, desc = "Surround node with {}" },
  },
}
