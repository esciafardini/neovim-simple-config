return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "clojure", "c", "lua", "vim", "query", "vimdoc", "html", "javascript" },
      auto_install = true,
      highlight = {
        enable = true,
      },
    })
  end
}
