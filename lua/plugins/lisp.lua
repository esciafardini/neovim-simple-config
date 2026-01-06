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

      vim.keymap.set("n", "<localleader>)", function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(")
      end, { desc = "Wrap in parens (no insert)" })

      local function wrap_brackets(opening)
        paredit.api.wrap_element_under_cursor("[", "]")
        if opening then
          vim.cmd("normal! F[")
          local keys = vim.api.nvim_replace_termcodes("a <Left>", true, false, true)
          vim.api.nvim_feedkeys(keys, "n", false)
        else
          vim.cmd("normal! F[")
        end
      end

      vim.keymap.set("n", "<localleader>[", function() wrap_brackets(true) end, { desc = "Wrap in brackets" })
      vim.keymap.set("n", "<localleader>]", function() wrap_brackets(false) end, { desc = "Wrap in brackets (no insert)" })

      local function wrap_braces()
        paredit.api.wrap_element_under_cursor("{", "}")
        vim.cmd("normal! F{")
      end
      vim.keymap.set("n", "<localleader>{", wrap_braces, { desc = "Wrap in braces" })
      vim.keymap.set("n", "<localleader>}", wrap_braces, { desc = "Wrap in braces" })

      vim.keymap.set("n", "<leader>ls", function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(alog/spy ")
      end, { desc = "Log Spy" })

      -- Shared function to find log/spy and log/daff positions in a buffer
      local function find_log_positions(bufnr)
        local ts = vim.treesitter
        local parser = ts.get_parser(bufnr, "clojure")
        if not parser then return {} end
        local trees = parser:parse()
        if not trees or not trees[1] then return {} end
        local root = trees[1]:root()

        local spy_query = ts.query.parse("clojure", [[
          (list_lit
            (sym_lit) @fn_name
            (_) @inner
            (#eq? @fn_name "log/spy"))
        ]])

        local daff_query = ts.query.parse("clojure", [[
          (list_lit
            (sym_lit) @fn_name
            (_)
            (_) @inner
            (#eq? @fn_name "log/daff"))
        ]])

        local positions = {}
        for id, node in spy_query:iter_captures(root, bufnr) do
          if spy_query.captures[id] == "inner" then
            local row, col = node:start()
            table.insert(positions, { row + 1, col })
          end
        end
        for id, node in daff_query:iter_captures(root, bufnr) do
          if daff_query.captures[id] == "inner" then
            local row, col = node:start()
            table.insert(positions, { row + 1, col })
          end
        end

        table.sort(positions, function(a, b)
          return a[1] > b[1] or (a[1] == b[1] and a[2] > b[2])
        end)

        return positions
      end

      -- Clean log/spy and log/daff from current buffer
      local function clean_logs_in_buffer()
        local positions = find_log_positions(0)
        for _, pos in ipairs(positions) do
          vim.api.nvim_win_set_cursor(0, pos)
          paredit.api.raise_element()
        end
        return #positions
      end

      -- Remove all log spy and log daff from file!!!
      vim.keymap.set("n", "<leader>lS", function()
        clean_logs_in_buffer()
      end, { desc = "Remove all log/spy and log/daff" })

      -- Clean all Clojure buffers on quit
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          -- Find all Clojure buffers with log calls
          local buffers_to_clean = {}
          local total_count = 0

          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "clojure" then
              local positions = find_log_positions(buf)
              if #positions > 0 then
                table.insert(buffers_to_clean, { buf = buf, count = #positions })
                total_count = total_count + #positions
              end
            end
          end

          if total_count == 0 then return end

          -- Prompt for confirmation
          local msg = string.format("Found %d log/spy or log/daff calls in %d buffer(s). Remove them? [y/n]: ",
            total_count, #buffers_to_clean)
          local choice = vim.fn.input(msg)

          if choice:lower() ~= "y" then
            print(" Skipped cleanup")
            return
          end

          -- Clean each buffer
          local original_buf = vim.api.nvim_get_current_buf()
          for _, item in ipairs(buffers_to_clean) do
            vim.api.nvim_set_current_buf(item.buf)
            clean_logs_in_buffer()
            vim.cmd("write")
          end
          vim.api.nvim_set_current_buf(original_buf)
          print(string.format(" Removed %d log calls", total_count))
        end,
      })

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
      require('mini.surround').setup({
        mappings = {
          add = 'sa',
          delete = 'ds',
          replace = 'cs',
          update_n_lines = 'sn',
        },
      })
      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
    end,
  },
}
