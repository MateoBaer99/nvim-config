return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local has = function(bin)
      return vim.fn.executable(bin) == 1
    end

    local lsp_servers = {
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "lua_ls",
      "graphql",
      "emmet_ls",
      "prismals",
      "pyright",
      "intelephense",
      "zls",
      "rust_analyzer",
      "clangd",
      "serve_d",
      "jsonls",
      "templ",
    }

    if has("cargo") and has("nix") then
      table.insert(lsp_servers, "nil_ls")
    end

    if has("ghcup") then
      table.insert(lsp_servers, "hls")
    end

    if has("go") then
      table.insert(lsp_servers, "gopls")
    end

    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      automatic_enable = false,
      -- list of servers for mason to install
      ensure_installed = lsp_servers,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "ruff", -- python linter/formatter
        "eslint_d", -- js linter
        "alejandra", -- nix formatter
        "fourmolu", -- haskell formatter
      },
    })
  end,
}
