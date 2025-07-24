-- generic vim settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Conjure Override K setting
vim.g["conjure#mapping#doc_word"] = "gk"

-- Macros
vim.fn.setreg('d', ',walog/daff lywhi pl(')
vim.fn.setreg('s', ',walog/spy ')
vim.fn.setreg('p', 'v%p')
vim.fn.setreg('x', 'v%x')
vim.fn.setreg('y', 'v%y')
vim.fn.setreg('b', 'ggVG,w')

-- Move blocks of text
vim.keymap.set('v', 'K', ":move '<-2<CR>gv-gv")
vim.keymap.set('v', 'J', ":move '<+1<CR>gv-gv")
