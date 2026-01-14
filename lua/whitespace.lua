-- Whitespace cleanup on quit
local function has_trailing_whitespace(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match("%s+$") then
      return true
    end
  end
  return false
end

local function clean_whitespace_in_buffer(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local cleaned = {}
  for _, line in ipairs(lines) do
    table.insert(cleaned, (line:gsub("%s+$", "")))
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, cleaned)
end

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local buffers_with_whitespace = {}

    for _, buffer in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      local bufnr = buffer["bufnr"]
      if has_trailing_whitespace(bufnr) then
        table.insert(buffers_with_whitespace, bufnr)
      end
    end

    if #buffers_with_whitespace == 0 then return end

    local msg = string.format("Found trailing whitespace in %d buffer(s). Clean up? [y/n]: ",
      #buffers_with_whitespace)
    local choice = vim.fn.input(msg)

    if choice:lower() ~= "y" then
      print(" Skipped cleanup")
      return
    end

    local original_buf = vim.api.nvim_get_current_buf()

    local ok, err = pcall(function()
      for _, bufnr in ipairs(buffers_with_whitespace) do
        clean_whitespace_in_buffer(bufnr)
        vim.api.nvim_set_current_buf(bufnr)
        vim.cmd("write")
      end
    end)

    vim.api.nvim_set_current_buf(original_buf)

    if not ok then
      vim.notify("Cleanup error: " .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})
