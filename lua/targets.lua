local M = {}

M.config = {
  notify = true,
  keymaps = {
    yank_above = "<leader>yk",
    yank_below = "<leader>yj",
    delete_above = "<leader>dk",
    delete_below = "<leader>dj",
  },
}

local function check_and_maybe_execute(direction, cmd)
  local modifier = (direction == "down" and 1) or -1
  local modified_count = vim.v.count1 * modifier
  local target = vim.fn.line(".") + modified_count
  if target < 1 and direction == "up" then
    vim.notify("No line " .. vim.v.count1 .. " above", vim.log.levels.WARN)
    return false
  elseif target > vim.fn.line("$") and direction == "down" then
    vim.notify("No line " .. vim.v.count1 .. " below", vim.log.levels.WARN)
    return false
  else
    vim.cmd(":" .. target .. cmd)
    return true
  end
end

function M.yank_above()
  if check_and_maybe_execute("up", "y") and M.config.notify then
    vim.notify("Yanked line " .. vim.v.count1 .. " above current")
  end
end

function M.yank_below()
  if check_and_maybe_execute("down", "y") and M.config.notify then
    vim.notify("Yanked line " .. vim.v.count1 .. " below current")
  end
end

function M.delete_above()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if check_and_maybe_execute("up", "d") and M.config.notify then
    vim.notify("Deleted " .. vim.v.count1 .. " lines above current")
  end
  vim.fn.cursor(line, col)
end

function M.delete_below()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if check_and_maybe_execute("down", "d") and M.config.notify then
    vim.notify("Deleted " .. vim.v.count1 .. " lines below current")
  end
  vim.fn.cursor(line, col)
end

function M.setup(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})

  local km = M.config.keymaps
  if km.yank_above then
    vim.keymap.set("n", km.yank_above, M.yank_above, { desc = "Yank line above" })
  end
  if km.yank_below then
    vim.keymap.set("n", km.yank_below, M.yank_below, { desc = "Yank line below" })
  end
  if km.delete_above then
    vim.keymap.set("n", km.delete_above, M.delete_above, { desc = "Delete line above" })
  end
  if km.delete_below then
    vim.keymap.set("n", km.delete_below, M.delete_below, { desc = "Delete line below" })
  end
end

return M
