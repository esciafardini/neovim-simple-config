return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()

    local ensure_installed = {
      "lua-language-server",
      "ruby-lsp",
      "clojure-lsp",
      "basedpyright",
      "gopls",
      "typescript-language-server",
      "clangd",
    }

    local registry = require("mason-registry")
    registry.refresh(function()
      for _, name in ipairs(ensure_installed) do
        local pkg = registry.get_package(name)
        if not pkg:is_installed() then
          pkg:install()
        end
      end
    end)
  end,
}
