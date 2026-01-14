return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>e",
      function()
        local path = vim.fn.expand("%:p")
        if path ~= "" and vim.fn.filereadable(path) == 1 then
          vim.cmd("Neotree filesystem reveal float")
        else
          vim.cmd("Neotree filesystem float")
        end
      end,
      desc = "File Explorer"
    },
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
