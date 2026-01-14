-- Find instances of log/spy, log/daff
-- take some time to understand this....
local function find_log_positions(bufnr)
  local ts = vim.treesitter
  local parser = ts.get_parser(bufnr, "clojure")
  if not parser then return {} end
  local trees = parser:parse()
  if not trees or not trees[1] then return {} end
  local root = trees[1]:root()

  -- these are compiled pattern matchers
  --  can walk trees & return nodes w/ ids
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

-- generate random 3-letter variable name
local function randomVarName()
  local length = 3
  local array = {}
  for i = 1, length do
    array[i] = string.char(math.random(97, 122))
  end
  return table.concat(array)
end

return {
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
      vim.cmd("normal! F[")
      if insert_after_bool then
        vim.cmd("normal! l")
        vim.api.nvim_put({ " " }, "c", false, false)
        vim.cmd("startinsert")
      end
    end

    vim.keymap.set("n", "<localleader>w",
      function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(a ")
        vim.cmd("startinsert")
      end)

    vim.keymap.set("n", "<localleader>)",
      function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(")
      end)

    vim.keymap.set("n", "<localleader>[", function() wrap_brackets(true) end)
    vim.keymap.set("n", "<localleader>]", function() wrap_brackets(false) end)
    vim.keymap.set("n", "<localleader>{", wrap_braces)
    vim.keymap.set("n", "<localleader>}", wrap_braces, { desc = "Wrap in braces" })
    vim.keymap.set("n", "(", paredit.api.move_to_prev_element_head)
    vim.keymap.set("n", ")", paredit.api.move_to_next_element_head)

    vim.keymap.set("n", "<leader>ls",
      function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(alog/spy ")
      end)

    vim.keymap.set("n", "<leader>ld",
      function()
        paredit.api.wrap_element_under_cursor("(", ")")
        vim.cmd("normal! F(alog/daff " .. randomVarName() .. " ")
        vim.cmd("normal! b")
      end, { desc = "Log Daff" })

    -- Clean log/spy and log/daff from current buffer
    local function clean_logs_in_buffer()
      local positions = find_log_positions(0)
      for _, pos in ipairs(positions) do
        vim.api.nvim_win_set_cursor(0, pos)
        paredit.api.raise_element()
      end
      return #positions
    end

    vim.keymap.set("n", "<leader>lS", clean_logs_in_buffer)

    paredit.setup()
  end
}
