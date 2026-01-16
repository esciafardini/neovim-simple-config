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
  },
}
