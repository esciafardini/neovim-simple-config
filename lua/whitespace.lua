-- Whitespace cleanup
local function clean_whitespace_in_buffer(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local cleaned = {}
  local count = 0
  for _, line in ipairs(lines) do
    local new_line, subs = line:gsub("%s+$", "")
    count = count + subs
    table.insert(cleaned, new_line)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, cleaned)
  return count
end

vim.keymap.set("n", "<leader>cw", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local count = clean_whitespace_in_buffer(bufnr)
  if count > 0 then
    vim.notify(string.format("Cleaned %d line(s)", count), vim.log.levels.INFO)
  else
    vim.notify("No trailing whitespace found", vim.log.levels.INFO)
  end
end, { desc = "Clean trailing whitespace" })
