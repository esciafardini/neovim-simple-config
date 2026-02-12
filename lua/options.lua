-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Old World Vim
-- Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","
-- Clipboard (yank to system clipboard)
vim.opt.clipboard = "unnamedplus"
-- Cursor Display (highlight the line number)
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
-- Line numbers (yes & relative)
vim.opt.number = true
vim.opt.relativenumber = true
-- Indentation (tabs are actually 2 spaces, and tab characters = 2 spaces long)
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
-- Search (case-insensitive unless there are capital letters)
vim.opt.smartcase = true
vim.opt.ignorecase = true
-- Find and replace preview
vim.opt.inccommand = "split"
-- Scrolling (10 line buffer scrolling, don't wrap when text goes off screen)
vim.opt.scrolloff = 10
vim.opt.wrap = false
-- Window Split Direction
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Misc (Use modern colors, persist undo history, visual block mode extension)
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = "block"
-- for obsidian to stfu
vim.opt.conceallevel = 1
vim.o.background = "dark"

-- Keymaps
vim.keymap.set("n", "c(", "f(ci(", { desc = "change inside next parens" })
vim.keymap.set("v", "J", ":move '>+1<CR>gv", { desc = "Move block downwards" })
vim.keymap.set("v", "K", ":move '<-2<CR>gv", { desc = "Move block upwards" })
vim.keymap.set("n", "<C-b>", "<C-u>", { desc = "Halfscroll up" })
vim.keymap.set("n", "<C-f>", "<C-d>", { desc = "Halfscroll down" })
vim.keymap.set("n", "<leader>h", ":nohl<CR>", { desc = "Unhighlight" })
vim.keymap.set("n", "<leader>sr", ":%s/", { desc = "Search and replace" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set('n', '<leader>r', ':set relativenumber!<CR>')
vim.keymap.set('n', '<leader>S', ':set spell!<CR>')

vim.api.nvim_create_user_command("Rtfm", "tab help toc", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})

-- Prevent Bad Formatting for Clojure Routes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "clojure",
  callback = function()
    local existing = vim.g.clojure_fuzzy_indent_patterns or {}
    vim.g.clojure_fuzzy_indent_patterns = vim.list_extend(existing,
      { "^dofor$", "^GET$", "^POST$", "^PUT$", "^PATCH$", "^DELETE$", "^ANY$" })
  end
})

-- Disable swap files for Obsidian vault (synced externally)
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = vim.fn.expand("~") .. "/obsidian/*",
  callback = function()
    vim.opt_local.swapfile = false
  end,
})

-- Lisp bracket auto-pairing
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    local paren_pairs = { ["("] = ")", ["["] = "]", ["{"] = "}" }
    for open, close in pairs(paren_pairs) do
      vim.keymap.set("i", open, open .. close .. "<Left>")
    end
  end
})

vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#3d3160", fg = "#76946A" })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = "Highlight when yanking it",
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "YankHighlight", timeout = 1000 })
  end,
})

vim.filetype.add({
  extension = {
    fnl = "fennel",
    fnlm = "fennel",
  },
})

-- Save foldes
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  pattern = { "*.*" },
  desc = "Save view (folds) when closing file",
  command = "mkview"
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*.*" },
  desc = "Load view (folds) when opening file",
  command = "silent! loadview"
})

require('whitespace').setup()
