-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

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
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = "block"
vim.opt.wrap = false

-- Strip trailing whitespace while preserving cursor position
local function strip_trailing_whitespace()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- save cursor
  vim.cmd([[%s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, { row, col }) -- restore cursor
end

-- Autocmd on BufWritePre
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = strip_trailing_whitespace,
})

-- Prevent Bad Formatting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "clojure",
  callback = function ()
    local existing = vim.g.clojure_fuzzy_indent_patterns or {}
    vim.g.clojure_fuzzy_indent_patterns = vim.list_extend(existing, { "^dofor$", "^GET$", "^POST$", "^PUT$", "^PATCH$", "^DELETE$", "^ANY$" })
  end
})

-- Keymaps
vim.keymap.set("v", "J", ":move '>+1<CR>gv-gv", { desc = "Move block downwards" })
vim.keymap.set("v", "K", ":move '<-2<CR>gv-gv", { desc = "Move block updwards" })
vim.keymap.set("n", "<C-f>", "<C-d>", { desc = "Halfscroll down" })
vim.keymap.set("n", "<C-b>", "<C-u>", { desc = "Halfscroll up" })
vim.keymap.set("n", "<leader>h", ":nohl<CR>", { desc = "Unhighlight" })
vim.keymap.set("i", "jkj", "<Esc>", { noremap = false })