return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require("ayu").setup({
        terminal = true,
        overrides = {
          Normal = { bg = "None" },
          NormalFloat = { bg = "None" },
        },
      })
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        transparent_mode = true,
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      light_style = "day",
      terminal_colors = true,
      transparent = true,
    },
  },
  {
    "tanvirtin/monokai.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai").setup({
        italics = true,
        custom_hlgroups = {
          Normal = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
        },
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      flavour = "mocha",
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        transparency = true,
      },
    },
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "deep",
      transparent = true,
    },
  },
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 999,
    cmd = "Themery",
      keys = {
        { "<leader>ut", "<cmd>Themery<CR>", desc = "Open theme picker" },
      },
    config = function()
      local function apply_transparency()
        local groups = {
          "Normal",
          "NormalNC",
          "NormalFloat",
          "FloatBorder",
          "SignColumn",
          "EndOfBuffer",
          "FoldColumn",
          "CursorColumn",
          "VertSplit",
          "WinSeparator",
          "StatusLine",
          "StatusLineNC",
          "TabLineFill",
          "WinBar",
          "WinBarNC",
          "NvimTreeNormal",
          "NvimTreeNormalNC",
          "NvimTreeEndOfBuffer",
          "NeoTreeNormal",
          "NeoTreeNormalNC",
          "BufferLineFill",
          "BufferLineBackground",
          "BufferLineTabClose",
          "TelescopeNormal",
          "TelescopeBorder",
          "TelescopePromptNormal",
          "TelescopePromptBorder",
          "TelescopeResultsNormal",
          "TelescopeResultsBorder",
          "TelescopePreviewNormal",
          "TelescopePreviewBorder",
        }

        for _, group in ipairs(groups) do
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
          if ok and next(hl) ~= nil then
            hl.bg = nil
            hl.ctermbg = nil
            vim.api.nvim_set_hl(0, group, hl)
          end
        end
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("mateo.transparency", { clear = true }),
        callback = apply_transparency,
      })

      require("themery").setup({
        livePreview = true,
        themes = {
          {
            name = "Ayu Mirage",
            colorscheme = "ayu-mirage",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Ayu Dark",
            colorscheme = "ayu-dark",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Gruvbox Dark",
            colorscheme = "gruvbox",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Tokyo Night Storm",
            colorscheme = "tokyonight-storm",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Tokyo Night Moon",
            colorscheme = "tokyonight-moon",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Monokai",
            colorscheme = "monokai",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Monokai Pro",
            colorscheme = "monokai_pro",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Monokai Soda",
            colorscheme = "monokai_soda",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Monokai Ristretto",
            colorscheme = "monokai_ristretto",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Catppuccin Mocha",
            colorscheme = "catppuccin-mocha",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Catppuccin Macchiato",
            colorscheme = "catppuccin-macchiato",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Kanagawa Wave",
            colorscheme = "kanagawa-wave",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Kanagawa Dragon",
            colorscheme = "kanagawa-dragon",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Rose Pine Main",
            colorscheme = "rose-pine",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "Rose Pine Moon",
            colorscheme = "rose-pine-moon",
            before = [[vim.opt.background = "dark"]],
          },
          {
            name = "OneDark Deep",
            colorscheme = "onedark",
            before = [[vim.opt.background = "dark"]],
          },
        },
      })

      if not vim.g.colors_name then
        vim.cmd.colorscheme("ayu-mirage")
      end

      apply_transparency()
    end,
  },
}
