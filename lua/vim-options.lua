-- generic vim settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set cursorline")
vim.cmd("set cursorlineopt=number")

-- Conjure Override K setting
vim.g["conjure#mapping#doc_word"] = "gk"

-- Move blocks of text
vim.keymap.set("v", "J", ":move '>+1<CR>gv-gv")
vim.keymap.set("v", "K", ":move '<-2<CR>gv-gv")

-- erase all white space on save:
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function()
		vim.cmd([[%s/\s\+$//e]])
	end,
})

-- prevent bad formatting
vim.cmd([[
autocmd FileType clojure let g:clojure_fuzzy_indent_patterns+=['^dofor$', '^GET$', '^POST$', '^PUT$', '^PATCH$', '^DELETE$', '^ANY$']
]])

-- auto close neotree
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.bo.buftype == '' then vim.cmd('Neotree close') end
  end,
})
