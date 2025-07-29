-- Generic vim settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set cursorline")
vim.cmd("set cursorlineopt=number")
vim.cmd("set clipboard+=unnamedplus")

-- Conjure Override K setting
vim.g["conjure#mapping#doc_word"] = "gk"

-- Erase all white space on save:
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Prevent bad formatting
vim.cmd([[
autocmd FileType clojure let g:clojure_fuzzy_indent_patterns+=['^dofor$', '^GET$', '^POST$', '^PUT$', '^PATCH$', '^DELETE$', '^ANY$']
]])

-- Keymaps
vim.keymap.set("v", "J", ":move '>+1<CR>gv-gv", { desc = "Move block downwards" })
vim.keymap.set("v", "K", ":move '<-2<CR>gv-gv", { desc = "Move block updwards" })
vim.keymap.set("n", "<C-f>", "<C-d>", { desc = "Halfscroll down" })
vim.keymap.set("n", "<C-b>", "<C-u>", { desc = "Halfscroll up" })
vim.keymap.set("n", " h", ":nohl<CR>", { desc = "Unhighlight" })
