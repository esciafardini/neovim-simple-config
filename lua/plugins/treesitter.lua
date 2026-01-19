---@diagnostic disable: missing-fields
local function get_node()
  local node = vim.treesitter.get_node()
  if node then
    vim.notify(node:type())
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V',  -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = true,
          },
        },
      }
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "clojure", "html", "javascript", "lua", "query", "ruby", "vim", "vimdoc" },
        auto_install = true,
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>ss",    --scope select
            node_incremental = "<leader>si",  --scope increase
            node_decremental = "<leader>sd",  --scope decrease
            scope_incremental = "<leader>sc", --scope creep
          },
        },
      })
    end,
    keys = {
      { "<leader>sn", get_node, desc = "Get node" },
    },
  }
}
