local function findStart(char)
  vim.cmd("normal! F" .. char)
end

local function insertAtStart(char)
  vim.cmd("normal! F" .. char .. "a ")
  vim.cmd("startinsert")
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

local function raise_element()
  local paredit = require("nvim-paredit")
  paredit.api.raise_element()
end

local function wrap_element(open, close)
  local paredit = require("nvim-paredit")
  paredit.api.wrap_element_under_cursor(open, close)
end

local function wrap_and_position(open, close, insert_mode)
  wrap_element(open, close)
  if insert_mode then
    insertAtStart(open)
  else
    findStart(open)
  end
end

local function wrap_log_spy()
  wrap_element("(", ")")
  findStart("(")
  vim.cmd("normal! alog/spy ")
end

local function wrap_log_daff()
  wrap_element("(", ")")
  findStart("(")
  vim.cmd("normal! alog/daff " .. randomVarName() .. " ")
end

-- Clean log/spy and log/daff from current buffer
local function clean_logs_in_buffer()
  local positions = find_log_positions(0)
  for _, pos in ipairs(positions) do
    vim.api.nvim_win_set_cursor(0, pos)
    raise_element()
  end
  return #positions
end

return {
  "julienvincent/nvim-paredit",
  ft = { "clojure", "fennel", "scheme", "lisp" },
  config = function()
    require("nvim-paredit").setup({})

    local lisp_fts = { clojure = true, fennel = true, scheme = true, lisp = true }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "clojure", "fennel", "scheme", "lisp" },
      callback = function()
        local opts = { buffer = true }
        vim.keymap.set("n", "<localleader>w", function() wrap_and_position("(", ")", true) end, vim.tbl_extend("force", opts, { desc = "Wrap in parens and insert" }))
        vim.keymap.set("n", "<localleader>)", function() wrap_and_position("(", ")", false) end, vim.tbl_extend("force", opts, { desc = "Wrap in parens" }))
        vim.keymap.set("n", "<localleader>[", function() wrap_and_position("[", "]", true) end, vim.tbl_extend("force", opts, { desc = "Wrap in brackets and insert" }))
        vim.keymap.set("n", "<localleader>]", function() wrap_and_position("[", "]", false) end, vim.tbl_extend("force", opts, { desc = "Wrap in brackets" }))
        vim.keymap.set("n", "<localleader>{", function() wrap_and_position("{", "}", false) end, vim.tbl_extend("force", opts, { desc = "Wrap in braces" }))
        vim.keymap.set("n", "<localleader>}", function() wrap_and_position("{", "}", false) end, vim.tbl_extend("force", opts, { desc = "Wrap in braces" }))
        vim.keymap.set("n", "(", function() require("nvim-paredit").api.move_to_parent_form_start() end, vim.tbl_extend("force", opts, { desc = "Go to parent form start" }))
        vim.keymap.set("n", ")", function() require("nvim-paredit").api.move_to_parent_form_end() end, vim.tbl_extend("force", opts, { desc = "Go to parent form end" }))

        if vim.bo.filetype == "clojure" then
          vim.keymap.set("n", "<leader>ls", wrap_log_spy, vim.tbl_extend("force", opts, { desc = "Log Spy" }))
          vim.keymap.set("n", "<leader>ld", wrap_log_daff, vim.tbl_extend("force", opts, { desc = "Log Daff" }))
          vim.keymap.set("n", "<leader>lS", clean_logs_in_buffer, vim.tbl_extend("force", opts, { desc = "Clean logs in buffer" }))
        end
      end,
    })
  end,
}
