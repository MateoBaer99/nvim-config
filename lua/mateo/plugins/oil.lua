return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    default_file_explorer = true,
    columns = { "icon" },
    view_options = {
      show_hidden = false,
    },
    float = {
      border = "rounded",
    },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-s>"] = false,
      ["<C-t>"] = false,
    },
  },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
    { "<leader>eo", "<cmd>Oil<CR>", desc = "Open oil explorer" },
    { "<leader>eO", "<cmd>Oil --float<CR>", desc = "Open floating oil explorer" },
  },
}
