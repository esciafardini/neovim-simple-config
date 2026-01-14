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
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", function() open_neotree() end, desc = "File Explorer" },
    { "<leader>ac", function() open_neotree(vim.fn.stdpath("config")) end, desc = "Nvim Config" },
  },
  config = function()
    require("neo-tree").setup({
      default_component_configs = {
        git_status = { enabled = false },
        diagnostics = { enabled = false },
      },
      git_status_async = false,
      enable_git_status = false,
      filesystem = {
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
    })
  end,
}
--complete
