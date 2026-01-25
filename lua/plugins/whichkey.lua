return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    -- Hide unused z keymaps
    local hidden_z = {
      "zH", "zL", "zs", "ze",       -- horizontal scroll
      "zg", "zw", "z=",             -- spell
      "zx", "zd", "zD", "zf", "zE", -- delete/create folds
      "zr", "zR",                   -- fold less
      "zm", "zM",                   -- fold more
      "zb", "zt", "zv", "z<cr>"     -- w/e
    }
    local hidden_specs = {}
    for _, key in ipairs(hidden_z) do
      table.insert(hidden_specs, { key, hidden = true })
    end
    wk.add(hidden_specs)

    wk.add({
      { "<leader>c", group = "Conjure" },
      { "<leader>f", group = "Telescope" },
      { "<leader>a", group = "Dashboard" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Treesitter" },
      { "<leader>g", group = "Git" },
    })
    vim.keymap.set("n", "<leader>?", function()
      require("which-key").show({ global = false })
    end, { desc = "Buffer Local Keymaps (which-key)" })
  end,
}
