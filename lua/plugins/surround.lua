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
    vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

    -- Quick surround shortcuts for quotes
    vim.keymap.set('n', ",'", "saiw'", { remap = true, desc = "Surround word with '" })
    vim.keymap.set('n', ',"', 'saiw"', { remap = true, desc = 'Surround word with "' })
    vim.keymap.set('n', ",`", "saiw`", { remap = true, desc = "Surround word with `" })
    vim.keymap.set('n', ",s'", "sais'", { remap = true, desc = "Surround sentence with '" })
    vim.keymap.set('n', ',s"', 'sais"', { remap = true, desc = 'Surround sentence with "' })
    vim.keymap.set('n', ",s`", "sais`", { remap = true, desc = "Surround sentence with `" })
  end,
}
