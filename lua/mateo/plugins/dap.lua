return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    dap.adapters.python = function(cb, config)
      if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
          type = "server",
          port = assert(port, "`connect.port` is required for a python `attach` configuration"),
          host = host,
          options = {
            source_filetype = "python",
          },
        })
      else
        cb({
          type = "executable",
          command = "python",
          args = { "-m", "debugpy.adapter" },
          options = {
            source_filetype = "python",
          },
        })
      end
    end

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          for _, venv in ipairs({ "venv", ".venv", "env", ".env" }) do
            local path = cwd .. "/" .. venv .. "/bin/python"
            if vim.fn.executable(path) == 1 then
              return path
            end
          end
          return "python"
        end,
      },
      {
        type = "python",
        request = "launch",
        name = "Debug pytest",
        module = "pytest",
        cwd = "${workspaceFolder}",
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          for _, venv in ipairs({ "venv", ".venv", "env", ".env" }) do
            local path = cwd .. "/" .. venv .. "/bin/python"
            if vim.fn.executable(path) == 1 then
              return path
            end
          end
          return "python"
        end,
      },
    }

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    local keymap = vim.keymap

    keymap.set("n", "<leader>db", function()
      require("dap").toggle_breakpoint()
    end, { desc = "Toggle breakpoint" })

    keymap.set("n", "<leader>dc", function()
      require("dap").continue()
    end, { desc = "Continue debugging" })

    keymap.set("n", "<leader>ds", function()
      require("dap").step_over()
    end, { desc = "Step over" })

    keymap.set("n", "<leader>di", function()
      require("dap").step_into()
    end, { desc = "Step into" })

    keymap.set("n", "<leader>do", function()
      require("dap").step_out()
    end, { desc = "Step out" })

    keymap.set("n", "<leader>dt", function()
      require("dap").terminate()
    end, { desc = "Terminate debugging" })

    keymap.set("n", "<leader>du", function()
      require("dapui").toggle()
    end, { desc = "Toggle DAP UI" })
  end,
}
