-- Globals
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Opts
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.scrolloff = 999
vim.opt.shiftwidth = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = "block"
vim.opt.wrap = false

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

-- Macros
local daff_macro = ",wlog/daff "
vim.fn.setreg("d", daff_macro)
vim.keymap.set("n", ",d", "@d")

vim.cmd[[imap zk <Esc>]]
vim.cmd[[let @s = ",wlog/spyzk("]]
vim.cmd[[let @d = ",wlog/daff"]]
