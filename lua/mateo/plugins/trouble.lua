return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  opts = {
    focus = true,
    auto_refresh = true,
    warn_no_results = true,
    open_no_results = false,
  },
  cmd = "Trouble",
  keys = {
    { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
    { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
  },
  config = function(_, opts)
    local trouble = require("trouble")
    trouble.setup(opts)

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      callback = function()
        if trouble.is_open("diagnostics") then
          trouble.refresh("diagnostics")
        end
      end,
    })
  end,
}
