local M = {}

M.config = {
  notify = true,
  keymap = '<leader>cw',
  trim_final_newlines = true,
}

local function clean_trailing(lines)
  local cleaned = {}
  local count = 0
  for _, line in ipairs(lines) do
    local new_line, subs = line:gsub('%s+$', '')
    count = count + subs
    table.insert(cleaned, new_line)
  end
  return cleaned, count
end

local function trim_final_newlines(lines)
  local trimmed = 0
  while #lines > 1 and lines[#lines] == '' do
    table.remove(lines)
    trimmed = trimmed + 1
  end
  return lines, trimmed
end

function M.clean(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local count = 0
  local trailing_count, final_count

  lines, trailing_count = clean_trailing(lines)
  count = count + trailing_count

  if M.config.trim_final_newlines then
    lines, final_count = trim_final_newlines(lines)
    count = count + final_count
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  if M.config.notify then
    if count > 0 then
      vim.notify(string.format('Cleaned %d line(s)', count), vim.log.levels.INFO)
    else
      vim.notify('No trailing whitespace found', vim.log.levels.INFO)
    end
  end

  return count
end

function M.setup(opts)
  M.config = vim.tbl_extend('force', M.config, opts or {})

  if M.config.keymap then
    vim.keymap.set('n', M.config.keymap, M.clean, { desc = 'Clean trailing whitespace' })
  end
end

return M
