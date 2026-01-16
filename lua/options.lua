-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Vim (Old World)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.expandtab = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = "block"
vim.opt.wrap = false

-- Keymaps
vim.keymap.set("i", "jkj", "<Esc>", { noremap = false })
vim.keymap.set("v", "J", ":move '>+1<CR>gv-gv", { desc = "Move block downwards" })
vim.keymap.set("v", "K", ":move '<-2<CR>gv-gv", { desc = "Move block upwards" })
vim.keymap.set("n", "<C-b>", "<C-u>", { desc = "Halfscroll up" })
vim.keymap.set("n", "<C-f>", "<C-d>", { desc = "Halfscroll down" })
vim.keymap.set("n", "<leader>h", ":nohl<CR>", { desc = "Unhighlight" })
vim.keymap.set("n", "<leader>ar", "<cmd>Telescope smart_open<cr>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
vim.keymap.del("n", "gc")

-- yank links up/down
vim.keymap.set('n', '<leader>yk', function()
  vim.cmd(':-' .. vim.v.count1 .. 'y')
  print("Yanked line " .. vim.v.count1 .. " (up)")
end)

vim.keymap.set('n', '<leader>yj', function()
  vim.cmd(':+' .. vim.v.count1 .. 'y')
  print("Yanked line " .. vim.v.count1 .. " (down)")
end)

-- Commands
vim.api.nvim_create_user_command("Rtfm", "tab help toc", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("W", "w", {})

-- Start screen keymap (like Dashboard)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1 then
      vim.keymap.set("n", "r", "<cmd>Telescope smart_open<cr>", { buffer = 0, desc = "Recent files" })
      vim.keymap.set("n", "f", "<cmd>Telescope smart_open<cr>", { buffer = 0, desc = "Find files" })
      vim.keymap.set("n", "w", "<cmd>Telescope live_grep<cr>", { buffer = 0, desc = "Find word" })
    end
  end
})

-- Prevent Bad Formatting for Clojure Routes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "clojure",
  callback = function()
    local existing = vim.g.clojure_fuzzy_indent_patterns or {}
    vim.g.clojure_fuzzy_indent_patterns = vim.list_extend(existing,
      { "^dofor$", "^GET$", "^POST$", "^PUT$", "^PATCH$", "^DELETE$", "^ANY$" })
  end
})
