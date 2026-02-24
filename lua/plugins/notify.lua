return {
  "rcarriga/nvim-notify",
  config = function()
    local nvim_notify = require("notify")
    vim.notify = function(msg, level, opts)
      local ok = pcall(nvim_notify, msg, level, opts)
      if not ok then
        vim.schedule(function() nvim_notify(msg, level, opts) end)
      end
    end
  end,
}
