local function check_and_maybe_execute(direction, cmd)
  local modifier = (direction == "down" and 1) or -1
  local modified_count = vim.v.count1 * modifier
  local target = vim.fn.line(".") + modified_count
  if target < 1 and direction == "up" then
    vim.notify("No line " .. vim.v.count1 .. " above", vim.log.levels.WARN)
    return
  elseif target > vim.fn.line("$") and direction == "down" then
    vim.notify("No line " .. vim.v.count1 .. " below", vim.log.levels.WARN)
    return
  else
    vim.cmd(":" .. target .. cmd)
  end
end

-- Yank (Target)
vim.keymap.set("n", "<leader>yk", function()
  check_and_maybe_execute("up", "y")
  vim.notify("Yanked line " .. vim.v.count1 .. " above current")
end, { desc = "Yank line above" })

vim.keymap.set("n", "<leader>yj", function()
  check_and_maybe_execute("down", "y")
  vim.notify("Yanked line " .. vim.v.count1 .. " below current")
end, { desc = "Yank line below" }) -- Commands

-- Delete (Target)
vim.keymap.set("n", "<leader>dk", function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  check_and_maybe_execute("up", "d")
  vim.notify("Deleted " .. vim.v.count1 .. " lines above current")
  vim.fn.cursor(line, col) -- reset cursor
end, { desc = "Delete line above" })

vim.keymap.set("n", "<leader>dj", function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  check_and_maybe_execute("down", "d")
  vim.notify("Deleted " .. vim.v.count1 .. " lines below current")
  vim.fn.cursor(line, col)
end, { desc = "Delete line below" })
