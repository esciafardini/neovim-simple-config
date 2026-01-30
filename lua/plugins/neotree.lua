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
          local initial_buf = vim.api.nvim_get_current_buf()

          if vim.fn.getcwd() == vim.env.HOME then
            require("telescope.builtin").oldfiles()
          else
            vim.cmd("Neotree filesystem float")
          end

          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(initial_buf)
              and vim.api.nvim_buf_get_name(initial_buf) == ""
              and vim.api.nvim_buf_line_count(initial_buf) <= 1
              and vim.api.nvim_buf_get_lines(initial_buf, 0, 1, false)[1] == "" then
              vim.api.nvim_buf_delete(initial_buf, { force = true })
            end
          end)
        end
      end,
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", function() open_neotree() end, desc = "File Explorer" },
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
