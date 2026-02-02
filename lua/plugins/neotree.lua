local function open_neotree(dir)
  local path = vim.fn.expand("%:p")
  local cmd = "Neotree filesystem float"
  if path ~= "" and vim.fn.filereadable(path) == 1 then
    cmd = cmd .. " reveal"
  end
  if dir then
    cmd = cmd .. " dir=" .. dir
  end
  vim.cmd(cmd)
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 then
          local bufnr = vim.api.nvim_get_current_buf()
          local current_dir = vim.fn.getcwd()
          local nvim_msg = "Neovim"
          vim.api.nvim_buf_set_name(bufnr, nvim_msg)
          if current_dir == "/Users/remote-dev/.config/nvim" then
            vim.cmd("Neotree filesystem float")
          else
            vim.cmd("FzfLua files")
          end
        end
      end,
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e",  function() open_neotree() end,                         desc = "File Explorer" },
    { "<leader>ac", function() open_neotree(vim.fn.stdpath("config")) end, desc = "Nvim Config" },
  },
  opts = {
    default_component_configs = {
      git_status = { enabled = false },
      diagnostics = { enabled = false },
    },
    git_status_async = false,
    enable_git_status = false,
    filesystem = {
      hijack_netrw_behavior = "open_current",
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = {
          ".idea", "target", "tmprelease", ".git", ".DS_Store", ".lein-failures",
          ".lein-repl-history", "acl.iml", "figwheel_server.log", "node_modules",
        },
      },
    },
  }
}
