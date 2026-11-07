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
      require("nvim-treesitter-textobjects").setup {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
          },
          include_surrounding_whitespace = true,
        },
      }
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require('nvim-treesitter').install({ "c", "clojure", "html", "javascript", "lua", "python", "query", "ruby", "typescript",
        "tsx", "vim", "vimdoc", "csv" })

      -- Enable treesitter highlighting; csv/tsv keep built-in per-column syntax
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if args.match ~= "csv" and args.match ~= "tsv" then
            pcall(vim.treesitter.start)
          end
        end
      })

      vim.keymap.set("n", "<leader>sn", get_node, { desc = "Get node type" })
    end,
  }
}
