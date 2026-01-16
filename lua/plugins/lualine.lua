return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- for "cool" file symbols
  config = function()
    vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-h>", ":bprev<CR>", { desc = "Previous buffer" })
    require('lualine').setup({
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
        },
        lualine_x = {
          { 'filetype',  icon_only = true },
          { 'lsp_status' }
        },
      },
    })
  end
}
--complete
