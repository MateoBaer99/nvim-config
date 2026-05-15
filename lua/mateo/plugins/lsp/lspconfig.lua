return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "SmiteshP/nvim-navic",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", ft = "lua" },
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local navic = require("nvim-navic")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

    local function has_bin(bin)
      if vim.fn.executable(bin) == 1 then
        return true
      end

      return vim.uv.fs_stat(mason_bin .. bin) ~= nil
    end

    vim.lsp.config("*", {
      root_markers = { ".git" },
      capabilities = capabilities,
    })

    vim.diagnostic.config({
      virtual_text = true,
      severity_sort = true,
      float = {
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
      },
    })

    local orig_open_floating_preview = vim.lsp.util.open_floating_preview

    ---@diagnostic disable-next-line: duplicate-set-field
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      opts.max_width = opts.max_width or 80
      opts.max_height = opts.max_height or 24
      opts.wrap = opts.wrap ~= false
      return orig_open_floating_preview(contents, syntax, opts, ...)
    end

    local lsp_attach_group = vim.api.nvim_create_augroup("mateo.lsp", { clear = true })
    local highlight_group = vim.api.nvim_create_augroup("mateo.lsp.highlight", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = lsp_attach_group,
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local buf = args.buf
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        map("n", "K", vim.lsp.buf.hover, "Show hover")
        map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Show LSP implementations")
        map("n", "go", vim.lsp.buf.type_definition, "Show LSP type definitions")
        map("n", "gr", vim.lsp.buf.references, "Show LSP references")
        map("n", "gs", vim.lsp.buf.signature_help, "Show signature help")
        map("n", "gl", vim.diagnostic.open_float, "Show line diagnostics")
        map("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "x" }, "<F3>", function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer or range")
        map("n", "<F4>", vim.lsp.buf.code_action, "Code action")
        map("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic")

        if client:supports_method("textDocument/documentHighlight") then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = buf,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = buf,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, buf)
        end
      end,
    })

    local function configure(server, config)
      vim.lsp.config(server, config or {})
    end

    configure("html")
    configure("tailwindcss")
    configure("prismals")
    configure("lua_ls", {
      root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = { enable = false },
        },
      },
    })
    configure("cssls", {
      root_markers = { "package.json", ".git" },
      settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
      },
    })
    configure("intelephense", {
      root_markers = { "composer.json", ".git" },
      settings = {
        intelephense = {
          files = {
            maxSize = 5000000,
          },
        },
      },
    })
    configure("ts_ls", {
      root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      settings = {
        completions = {
          completeFunctionCalls = true,
        },
      },
    })
    configure("zls", {
      root_markers = { "zls.json", "build.zig", ".git" },
      settings = {
        zls = {
          enable_build_on_save = true,
          build_on_save_step = "install",
          warn_style = false,
          enable_snippets = true,
        },
      },
    })
    configure("nil_ls", {
      root_markers = { "flake.nix", "default.nix", ".git" },
      settings = {
        ["nil"] = {
          formatting = {
            command = { "alejandra" },
          },
        },
      },
    })
    configure("rust_analyzer", {
      root_markers = { "Cargo.toml", "rust-project.json", ".git" },
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          formatting = {
            command = { "rustfmt" },
          },
        },
      },
    })
    configure("clangd", {
      root_markers = { "compile_commands.json", ".clangd", "configure.ac", "Makefile", ".git" },
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--completion-style=detailed",
      },
      init_options = {
        fallbackFlags = { "-std=c23" },
      },
    })
    configure("c3_lsp", {
      root_markers = { "project.json", "manifest.json", ".git" },
    })
    configure("serve_d", {
      root_markers = { "dub.sdl", "dub.json", ".git" },
    })
    configure("jsonls", {
      root_markers = { "package.json", ".git", "config.jsonc" },
    })
    configure("hls", {
      root_markers = { "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", ".git" },
      settings = {
        haskell = {
          formattingProvider = "fourmolu",
          plugin = {
            semanticTokens = { globalOn = false },
          },
        },
      },
    })
    configure("gopls", {
      root_markers = { "go.mod", "go.work", ".git" },
      settings = {
        gopls = {
          analyses = {
            unusedparams = false,
            ST1003 = false,
            ST1000 = false,
          },
          staticcheck = true,
        },
      },
    })
    configure("templ", {
      root_markers = { "go.mod", ".git" },
    })
    configure("svelte", {
      on_attach = function(client)
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = vim.api.nvim_create_augroup("mateo.lsp.svelte", { clear = true }),
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_fname(ctx.match) })
          end,
        })
      end,
    })
    configure("graphql", {
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })
    configure("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "templ" },
    })
    configure("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
    })

    vim.filetype.add({
      extension = {
        h = "c",
        c3 = "c3",
        d = "d",
        templ = "templ",
      },
    })

    local servers = {
      html = "vscode-html-language-server",
      tailwindcss = "tailwindcss-language-server",
      prismals = "prisma-language-server",
      lua_ls = "lua-language-server",
      cssls = "vscode-css-language-server",
      intelephense = "intelephense",
      ts_ls = "typescript-language-server",
      zls = "zls",
      nil_ls = "nil",
      rust_analyzer = "rust-analyzer",
      clangd = "clangd",
      c3_lsp = "c3lsp",
      serve_d = "serve-d",
      jsonls = "vscode-json-language-server",
      hls = "haskell-language-server-wrapper",
      gopls = "gopls",
      templ = "templ",
      svelte = "svelteserver",
      graphql = "graphql-lsp",
      emmet_ls = "emmet-ls",
      pyright = "pyright-langserver",
    }

    for server, bin in pairs(servers) do
      if has_bin(bin) then
        vim.lsp.enable(server)
      end
    end
  end,
}
