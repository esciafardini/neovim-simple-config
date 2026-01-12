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

      -- wrap in {}
      local function wrap_braces()
        paredit.api.wrap_element_under_cursor("{", "}")
        vim.cmd("normal! F{")
      end

      -- wrap in []
      local function wrap_brackets(insert_after_bool)
        paredit.api.wrap_element_under_cursor("[", "]")
        if insert_after_bool then
          vim.cmd("normal! F[")
          local keys = vim.api.nvim_replace_termcodes("a <Left>", true, false, true)
          vim.api.nvim_feedkeys(keys, "n", false)
        else
          vim.cmd("normal! F[")
        end
      end

      -- Find instances of log/spy, log/daff
      -- take some time to understand this....
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

      -- generate random 3-letter variable name
      local function randomVarName()
        local length = 3
        local array = {}
        for i = 1, length do
          array[i] = string.char(math.random(97, 122))
        end
        return table.concat(array)
      end

      vim.keymap.set("n", "<localleader>w", function() paredit.api.wrap_element_under_cursor("(", ")") vim.cmd("normal! F(a ") vim.cmd("startinsert") end, { desc = "Wrap in parens" })
      vim.keymap.set("n", "<localleader>)", function() paredit.api.wrap_element_under_cursor("(", ")") vim.cmd("normal! F(") end, { desc = "Wrap in parens (no insert)" })
      vim.keymap.set("n", "<localleader>[", function() wrap_brackets(true) end, { desc = "Wrap in brackets" })
      vim.keymap.set("n", "<localleader>]", function() wrap_brackets(false) end, { desc = "Wrap in brackets (no insert)" })
      vim.keymap.set("n", "<localleader>{", wrap_braces, { desc = "Wrap in braces" })
      vim.keymap.set("n", "<localleader>}", wrap_braces, { desc = "Wrap in braces" })
      vim.keymap.set("n", "<leader>ls", function() paredit.api.wrap_element_under_cursor("(", ")") vim.cmd("normal! F(alog/spy ") end, { desc = "Log Spy" })
      vim.keymap.set("n", "<leader>lS", function() clean_logs_in_buffer() end, { desc = "Remove all log/spy and log/daff" })
      vim.keymap.set("n", "<leader>ld",
        function()
          paredit.api.wrap_element_under_cursor("(", ")")
          vim.cmd("normal! F(alog/daff " .. randomVarName() .. " ")
          vim.cmd("normal! b")
        end, { desc = "Log Daff" })

      -- Clean all Clojure buffers on quit
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          -- Find all Clojure buffers with log calls
          local buffers_to_clean = {}
          local total_count = 0

          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buflisted and vim.bo[buf].filetype == "clojure" then
              local positions = find_log_positions(buf)
              if #positions > 0 then
                table.insert(buffers_to_clean, { buf = buf })
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

      paredit.setup()
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
        },
      })
      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

      -- Quick surround shortcuts for quotes
      vim.keymap.set('n', ",'", "saiw'", { remap = true, desc = "Surround word with '" })
      vim.keymap.set('n', ',"', 'saiw"', { remap = true, desc = 'Surround word with "' })
      vim.keymap.set('n', ",`", "saiw`", { remap = true, desc = "Surround word with `" })
      vim.keymap.set('n', ",s'", "sais'", { remap = true, desc = "Surround sentence with '" })
      vim.keymap.set('n', ',s"', 'sais"', { remap = true, desc = 'Surround sentence with "' })
      vim.keymap.set('n', ",s`", "sais`", { remap = true, desc = "Surround sentence with `" })
    end,
  },
}
