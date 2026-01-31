-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end

-- adds lazypath to runtime path
vim.opt.rtp:prepend(lazypath)

-- Lazy config
require("lazy").setup({
  change_detection = { enabled = false },
  spec = {
    { import = "plugins" },
  },
  checker = { enabled = true, notify = false },
  rocks = { enabled = false },
})
