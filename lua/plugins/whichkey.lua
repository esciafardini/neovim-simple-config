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
      "zb", "zt", "zv", "z<CR>",    -- b.s.
      "zo", "zO", "zc", "zC",       -- w/e, just use za, zA
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

      -- Fold commands (z)
      { "z", group = "Folds/View" },

      -- Single fold (under cursor)
      { "za", desc = "Toggle fold" },
      { "zA", desc = "Toggle fold (ALL levels)" },

      -- Global fold level (affects whole buffer)
      { "zm", desc = "↓ foldlevel (close more folds)" },
      { "zM", desc = "Close ALL folds in buffer" },
      { "zr", desc = "↑ foldlevel (open more folds)" },
      { "zR", desc = "Open ALL folds in buffer" },

      -- Navigation
      { "zj", desc = "Jump to next fold" },
      { "zk", desc = "Jump to prev fold" },

      -- Toggle folding entirely
      { "zi", desc = "Toggle folding on/off" },
      { "zn", desc = "Disable folding" },
      { "zN", desc = "Enable folding" },

      -- View
      { "zz", desc = "Center cursor line" },
    })
    vim.keymap.set("n", "<leader>?", function()
      require("which-key").show({ global = false })
    end, { desc = "Buffer Local Keymaps (which-key)" })
  end,
}
