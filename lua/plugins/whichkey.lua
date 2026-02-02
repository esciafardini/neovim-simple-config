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
      "zb", "zt", "zv", "z<CR>",    -- cursor to bottom/top/reveal/top+col1
      "zo", "zO", "zc", "zC",       -- open/close fold (lowercase=1 level, upper=all)
      "zi", "zm", "zr"              -- toggle/more/reduce folding
    }
    local hidden_specs = {}
    for _, key in ipairs(hidden_z) do
      table.insert(hidden_specs, { key, hidden = true })
    end
    wk.add(hidden_specs)

    wk.add({
      { "<leader>c", group = "Conjure" },
      { "<leader>f", group = "Lua FZF" },
      { "<leader>a", group = "Dashboard" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Treesitter" },
      { "<leader>g", group = "Git" },

      -- Fold commands (z)
      { "z", group = "Folds" },

      -- Single fold (under cursor)
      { "za", desc = "Toggle fold" },
      { "zA", desc = "Toggle fold (ALL levels)" },

      -- Global fold level (affects whole buffer)
      { "zM", desc = "Close ALL folds in buffer" },
      { "zR", desc = "Open ALL folds in buffer" },

      -- Navigation
      { "zj", desc = "Jump to next fold" },
      { "zk", desc = "Jump to prev fold" },

      -- Toggle folding entirely
      { "zn", desc = "Disable folding" },
      { "zN", desc = "Enable folding" },
    })
    vim.keymap.set("n", "<leader>?", function()
      require("which-key").show({ global = false })
    end, { desc = "Buffer Local Keymaps (which-key)" })
  end,
}
