return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    { "<leader>de", function() require("dap").continue() end,          desc = "Debug: Execute" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<leader>dc", function() require("dap").run_to_cursor() end,     desc = "Run to cursor" },
    { "<leader>dn", function() require("dap").continue() end,          desc = "Continue" },
    { "<leader>ds", function() require("dap").step_over() end,         desc = "Step over" },
    { "<leader>di", function() require("dap").step_into() end,         desc = "Step into" },
    { "<leader>do", function() require("dap").step_out() end,          desc = "Step out" },
    { "<leader>dr", function() require("dap").restart() end,           desc = "Restart" },
    { "<leader>dq", function() require("dap").terminate() end,         desc = "Terminate" },
    { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle UI" },
    { "<localleader>er", function() require("dapui").eval() end,       desc = "Eval expression",  mode = { "n", "v" } },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Condition: "))
      end,
      desc = "Conditional breakpoint"
    },
    {
      "<leader>dm",
      function()
        vim.cmd("write")
        local src = vim.fn.expand("%:p")
        local out = vim.fn.expand("%:p:r")
        local res = vim.system({ "cc", "-g", "-O0", src, "-o", out }, { text = true }):wait()
        if res.code == 0 then
          vim.notify("Built " .. vim.fn.fnamemodify(out, ":t") .. " (debug)", vim.log.levels.INFO)
        else
          vim.notify(res.stderr, vim.log.levels.ERROR)
        end
      end,
      desc = "Compile for debugging"
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup({ virt_text_pos = "eol" })

    -- lldb-dap from Homebrew LLVM (brew install llvm)
    dap.adapters.lldb = {
      type = "executable",
      command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
      name = "lldb",
    }

    local function pick_program()
      -- Default: binary with the same name as the current file, next to it
      local default = vim.fn.expand("%:p:r")
      return vim.fn.input("Executable: ", default, "file")
    end

    dap.configurations.c = {
      {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = pick_program,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
      {
        name = "Launch with args",
        type = "lldb",
        request = "launch",
        program = pick_program,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          return vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
        end,
      },
    }
    dap.configurations.cpp = dap.configurations.c

    -- Open/close UI automatically
    dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
  end,
}
