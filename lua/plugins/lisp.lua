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

      vim.keymap.set("n", "<localleader>w", function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(a ")
        vim.cmd("startinsert")
      end, { desc = "Wrap in parens" })

      local function wrap_brackets()
        paredit.api.wrap_element_under_cursor("[", "]")
        vim.cmd("normal! F[")
      end
      vim.keymap.set("n", "<localleader>b", wrap_brackets, { desc = "Wrap in brackets" })
      vim.keymap.set("n", "<localleader>[", wrap_brackets, { desc = "Wrap in brackets" })
      vim.keymap.set("n", "<localleader>]", wrap_brackets, { desc = "Wrap in brackets" })

      local function wrap_braces()
        paredit.api.wrap_element_under_cursor("{", "}")
        vim.cmd("normal! F{")
      end
      vim.keymap.set("n", "<localleader>m", wrap_braces, { desc = "Wrap in braces" })
      vim.keymap.set("n", "<localleader>{", wrap_braces, { desc = "Wrap in braces" })
      vim.keymap.set("n", "<localleader>}", wrap_braces, { desc = "Wrap in braces" })

      vim.keymap.set("n", "<leader>ls", function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(alog/spy ")
      end, { desc = "Log Spy" })

      -- Remove all log spy and log daff from file!!!
      vim.keymap.set("n", "<leader>lS", function()
        local ts = vim.treesitter
        local parser = ts.get_parser(0, "clojure")
        if not parser then return end
        local trees = parser:parse()
        if not trees or not trees[1] then return end
        local root = trees[1]:root()

        -- log/spy: (log/spy expr) -> keep 2nd element
        local spy_query = ts.query.parse("clojure", [[
          (list_lit
            (sym_lit) @fn_name
            (_) @inner
            (#eq? @fn_name "log/spy"))
        ]])

        -- log/daff: (log/daff label expr) -> keep 3rd element
        local daff_query = ts.query.parse("clojure", [[
          (list_lit
            (sym_lit) @fn_name
            (_)
            (_) @inner
            (#eq? @fn_name "log/daff"))
        ]])

        local positions = {}
        for id, node in spy_query:iter_captures(root, 0) do
          if spy_query.captures[id] == "inner" then
            local row, col = node:start()
            table.insert(positions, { row + 1, col })
          end
        end
        for id, node in daff_query:iter_captures(root, 0) do
          if daff_query.captures[id] == "inner" then
            local row, col = node:start()
            table.insert(positions, { row + 1, col })
          end
        end

        table.sort(positions, function(a, b)
          return a[1] > b[1] or (a[1] == b[1] and a[2] > b[2])
        end)

        for _, pos in ipairs(positions) do
          vim.api.nvim_win_set_cursor(0, pos)
          paredit.api.raise_element()
        end
      end, { desc = "Remove all log/spy and log/daff" })

      local function randomVarName()
        local length = 3
        local array = {}
        for i = 1, length do
          array[i] = string.char(math.random(97, 122))
        end
        return table.concat(array)
      end

      vim.keymap.set("n", "<leader>ld", function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(alog/daff " .. randomVarName() .. " ")
        vim.cmd("normal! b")
      end, { desc = "Log Daff" })

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
      require('mini.surround').setup
      {
        mappings = {
          add = 'sa',            -- Add surrounding in Normal and Visual modes
          delete = 'ds',         -- Delete surrounding
          replace = 'cs',        -- Replace surrounding
          update_n_lines = 'sn', -- Update `n_lines`
        },
        vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true }),
      }
    end,
  },
}
