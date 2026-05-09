return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap-python",
  },
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>ve", "<cmd>VenvSelect<CR>", desc = "Select Python Virtual Environment" },
  },
}
