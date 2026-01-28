local function is_obsidian_buffer(bufnr)
  -- just save and close if it's obsidian (i dont' care)
  local file_name = vim.api.nvim_buf_get_name(bufnr)
  return file_name:find(vim.fn.expand("~") .. "/obsidian", 1, true)
end

-- Close buffers by direction
local function close_buffers(direction)
  local current_bufnr = vim.api.nvim_get_current_buf()

  -- tbl_filter is like filter (in clj)
  local buffers = vim.tbl_filter(function(bufnr)
    return vim.bo[bufnr].buflisted
  end, vim.api.nvim_list_bufs())

  local closed, saved, skipped = 0, 0, 0

  for _, bufnr in ipairs(buffers) do
    local targeted_for_closing =
        (direction == "left" and bufnr < current_bufnr) or
        (direction == "right" and bufnr > current_bufnr) or
        (direction == "other" and bufnr ~= current_bufnr)
    local is_obsidian_file = is_obsidian_buffer(bufnr)
    local has_been_modified = vim.bo[bufnr].modified

    if targeted_for_closing and not has_been_modified then
      vim.api.nvim_buf_delete(bufnr, {})
      closed = closed + 1
    elseif targeted_for_closing and is_obsidian_file and has_been_modified then
      vim.api.nvim_buf_call(bufnr, function() vim.cmd('write') end)
      saved = saved + 1
      vim.api.nvim_buf_delete(bufnr, {})
      closed = closed + 1
    elseif targeted_for_closing and has_been_modified then
      skipped = skipped + 1
    end
  end

  local msg = "Closed " .. closed .. " buffer(s)"
  if saved > 0 then msg = msg .. ", saved " .. saved end
  if skipped > 0 then msg = msg .. ", skipped " .. skipped .. " unnamed or modified" end
  vim.notify(msg, vim.log.levels.INFO)
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- for "cool" file symbols
  init = function()
    vim.keymap.set("n", "<leader>bh", function() close_buffers("left") end, { desc = "Close buffers to left" })
    vim.keymap.set("n", "<leader>bl", function() close_buffers("right") end, { desc = "Close buffers to right" })
    vim.keymap.set("n", "<leader>bo", function() close_buffers("other") end, { desc = "Close other buffers" })
  end,
  opts = {
    tabline = {
      lualine_a = {
        {
          'buffers',
        }
      },
    },
    sections = {
      lualine_c = {
        'filename',
        { function() return ' 🌜 ' end, padding = { left = 1, right = 0 } },
        {
          function()
            return vim.bo.filetype:match('gitsigns') and 'BLAME' or ''
          end,
          color = { fg = '#ff9e64' },
        },
      },
      lualine_x = {
        { 'filetype',  icon_only = true },
        { 'lsp_status' }
      },
    },
  },
}
