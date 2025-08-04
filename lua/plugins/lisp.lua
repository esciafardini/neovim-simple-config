return {
  {
    'm4xshen/autoclose.nvim',
    config = function()
      require("autoclose").setup({
        keys = {
          [">"] = { escape = false, close = false, pair = "<>", disabled_filetypes = {} },
          ["'"] = { escape = false, close = false, pair = "''", disabled_filetypes = {} },
          ["`"] = { escape = false, close = false, pair = "``", disabled_filetypes = {} },
        },
      })
    end
  },
  {
    "julienvincent/nvim-paredit",
    config = function()
      local paredit = require("nvim-paredit")
      paredit.setup({
        keys = {
          -- Remove Surrounding
          ["<localleader>@"] = { paredit.unwrap.unwrap_form_under_cursor, "Splice sexp" },

          -- Slurping and Barfing
          [">)"] = { paredit.api.slurp_forwards, "Slurp forwards" },
          [">("] = { paredit.api.barf_backwards, "Barf backwards" },
          ["<)"] = { paredit.api.barf_forwards, "Barf forwards" },
          ["<("] = { paredit.api.slurp_backwards, "Slurp backwards" },

          -- Moving elements
          [">e"] = { paredit.api.drag_element_forwards, "Drag element right" },
          ["<e"] = { paredit.api.drag_element_backwards, "Drag element left" },

          -- Moving pairs (like key-values)
          [">p"] = { paredit.api.drag_pair_forwards, "Drag element pairs right" },
          ["<p"] = { paredit.api.drag_pair_backwards, "Drag element pairs left" },

          [">f"] = { paredit.api.drag_form_forwards, "Drag form right" },
          ["<f"] = { paredit.api.drag_form_backwards, "Drag form left" },

          -- Raising!
          ["<localleader>o"] = { paredit.api.raise_form, "Raise form" },
          ["<localleader>O"] = { paredit.api.raise_element, "Raise element" },

          ["E"] = {
            paredit.api.move_to_next_element_tail,
            "Jump to next element tail",
            -- by default all keybindings are dot repeatable
            repeatable = false,
            mode = { "n", "x", "o", "v" },
          },
          ["W"] = {
            paredit.api.move_to_next_element_head,
            "Jump to next element head",
            repeatable = false,
            mode = { "n", "x", "o", "v" },
          },
          ["T"] = {
            paredit.api.move_to_top_level_form_head,
            "Jump to top level form's head",
            repeatable = false,
            mode = { "n", "x", "v" },
          },
        },
      })
    end
  },
  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.surround').setup(
        {
          mappings = {
            --ssiw
            add = 'ss',            -- Add surrounding in Normal and Visual modes
            delete = 'ds',         -- Delete surrounding
            replace = 'cs',        -- Replace surrounding
            update_n_lines = 'sn', -- Update `n_lines`
          },
          vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true }),
        })
    end
  },
}
