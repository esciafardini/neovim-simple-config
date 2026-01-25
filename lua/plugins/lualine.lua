-- Close buffers by direction
local function close_buffers(direction)
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.tbl_filter(function(b)
    return vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  local closed = 0
  for _, buf in ipairs(buffers) do
    local should_close = (direction == "left" and buf < current)
        or (direction == "right" and buf > current)
        or (direction == "other" and buf ~= current)

    if should_close then
      vim.api.nvim_buf_delete(buf, {})
      closed = closed + 1
    end
  end
  vim.notify("Closed " .. closed .. " buffer(s)", vim.log.levels.INFO)
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
    options = {
      theme = 'auto'
    },
    tabline = {
      lualine_a = {
        {
          'buffers',
          fmt = function(name, context)
            local bufnr = context.bufnr
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            -- Respect :file renames for terminal buffers
            if vim.bo[bufnr].buftype == 'terminal' and not bufname:match('^term://') then
              return vim.fn.fnamemodify(bufname, ':t')
            end
            return name
          end
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
