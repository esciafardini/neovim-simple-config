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
vim.keymap.set("i", "jkj", "<Esc>", { noremap = false, desc = "Exit insert mode" })
vim.keymap.set("v", "J", ":move '>+1<CR>gv-gv", { desc = "Move block downwards" })
vim.keymap.set("v", "K", ":move '<-2<CR>gv-gv", { desc = "Move block upwards" })
vim.keymap.set("n", "<C-b>", "<C-u>", { desc = "Halfscroll up" })
vim.keymap.set("n", "<C-f>", "<C-d>", { desc = "Halfscroll down" })
vim.keymap.set("n", "<leader>h", ":nohl<CR>", { desc = "Unhighlight" })
vim.keymap.set("n", "<leader>b", ":echo bufnr('%')<CR>", { desc = "Get Bufnr" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>ar", "<cmd>Telescope smart_open<cr>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
vim.keymap.del("n", "gc")

-- yank links up/down
vim.keymap.set('n', '<leader>yk', function()
  local current = vim.fn.line('.')
  local target = current - vim.v.count1
  if target < 1 then
    vim.notify("No line " .. vim.v.count1 .. " above", vim.log.levels.WARN)
    return
  end
  vim.cmd(':' .. target .. 'y')
  vim.notify("Yanked line " .. vim.v.count1 .. " above current")
end, { desc = "Yank line above" })

vim.keymap.set('n', '<leader>yj', function()
  local current = vim.fn.line('.')
  local target = current + vim.v.count1
  if target > vim.fn.line('$') then
    vim.notify("No line " .. vim.v.count1 .. " below", vim.log.levels.WARN)
    return
  end
  vim.cmd(':' .. target .. 'y')
  vim.notify("Yanked line " .. vim.v.count1 .. " below current")
end, { desc = "Yank line below" })   -- Commands

vim.api.nvim_create_user_command("Rtfm", "tab help toc", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Q", "q", {})
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

vim.fn.jobstart(
  'curl -s https://api.github.com/repos/lewis6991/gitsigns.nvim/releases/latest',
  {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local json = vim.fn.json_decode(table.concat(data))
      local remote_version = json.tag_name
      local local_version = "v2.0.0"  -- your version
      if remote_version ~= local_version then
        vim.notify("gitsigns update available: " .. remote_version)
      else
        vim.notify("gitsigns still on version " .. remote_version)
      end
    end,
  }
)
