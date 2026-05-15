return {
  "folke/noice.nvim",
  event = "VeryLazy",
  cmd = "Noice",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#000000",
        render = "wrapped-compact",
        timeout = 3000,
      },
    },
  },
  opts = {
    lsp = {
      progress = {
        enabled = false,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = false,
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    vim.notify = require("notify")
  end,
  keys = {
    {
      "<leader>nn",
      function()
        require("noice").cmd("history")
      end,
      desc = "Open message history",
    },
    {
      "<leader>nl",
      function()
        require("noice").cmd("last")
      end,
      desc = "Open last message",
    },
  },
}
