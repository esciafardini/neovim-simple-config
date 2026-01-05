-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- checks for existence of lazy.nvim
if not (vim.uv).fs_stat(lazypath) then
  -- clones from github if it's not present
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
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
