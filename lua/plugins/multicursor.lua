return {
  "jake-stewart/multicursor.nvim",
  branch = "1.*",
  event = "VeryLazy",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Visual block → multicursor (your main use case)
    set("x", "I", mc.insertVisual)
    set("x", "A", mc.appendVisual)

    -- Escape to clear cursors when done
    set("n", "<Esc>", function()
      if mc.hasCursors() then
        mc.clearCursors()
      else
        vim.cmd("nohlsearch")
      end
    end)
  end,
}
