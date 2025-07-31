return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects"
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "clojure", "html", "javascript", "lua", "query", "vim", "vimdoc" },
        auto_install = true,
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>ss",  --scope select
            node_incremental = "<leader>si", --scope increase
            node_decremental = "<leader>sd", --scope decrease
            scope_incremental = "<leader>sc", --scope creep
          },
        },
      })
    end
  }
}
