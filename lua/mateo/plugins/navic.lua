return {
  "SmiteshP/nvim-navic",
  lazy = false,
  opts = {
    highlight = true,
    separator = " > ",
    lsp = {
      auto_attach = false,
    },
  },
  config = function(_, opts)
    local navic = require("nvim-navic")
    navic.setup(opts)

    _G.mateo_winbar = function()
      local excluded = {
        alpha = true,
        oil = true,
        NvimTree = true,
        lazy = true,
        mason = true,
        noice = true,
        Trouble = true,
      }

      local filetype = vim.bo.filetype
      if excluded[filetype] then
        return ""
      end

      if navic.is_available() then
        return " " .. navic.get_location()
      end

      local name = vim.fn.expand("%:t")
      if name == "" then
        return ""
      end

      return " " .. name
    end

    vim.o.winbar = "%{%v:lua.mateo_winbar()%}"
  end,
}
