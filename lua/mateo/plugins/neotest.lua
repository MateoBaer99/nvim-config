return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-python")({
          runner = "pytest",
          python = "python",
        }),
      },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>tt", function()
      neotest.run.run()
    end, { desc = "Run nearest test" })

    keymap.set("n", "<leader>tT", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Run all tests in file" })

    keymap.set("n", "<leader>ts", function()
      neotest.run.stop()
    end, { desc = "Stop nearest test" })

    keymap.set("n", "<leader>to", function()
      neotest.output.open()
    end, { desc = "Show test output" })

    keymap.set("n", "<leader>tp", function()
      neotest.summary.toggle()
    end, { desc = "Toggle test summary" })
  end,
}
