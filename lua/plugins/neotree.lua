return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree filesystem reveal float<cr>", desc = "File Explorer" },
  },
  config = function()
    require("neo-tree").setup({
      default_component_configs = {
        git_status = { enabled = false },
        diagnostics = { enabled = false },
      },
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
