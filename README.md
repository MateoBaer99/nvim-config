# Config Nvim

A modular Neovim configuration powered by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Features

- **65+ plugins** — lazy-loaded for fast startup
- **Modular Lua structure** — one file per plugin under `lua/mateo/plugins/`
- **Full LSP support** — 20+ language servers via Mason + lspconfig
- **Formatting & linting** — conform.nvim (prettier, stylua, ruff) + nvim-lint (eslint_d, ruff)
- **Debugging** — nvim-dap + dap-ui with Python (debugpy/pytest)
- **Testing** — neotest with pytest
- **8 themes / 16 variants** — Ayu (default), Gruvbox, Tokyo Night, Catppuccin, Kanagawa, Rose Pine, Monokai, OneDark — switchable via themery.nvim
- **Transparency** — applied globally across all themes
- **Rich UI** — alpha-nvim dashboard, bufferline tabs, lualine statusline, noice.nvim notifications, which-key popups, trouble diagnostics
- **Dual file explorers** — nvim-tree (sidebar) + oil.nvim (vim-native editing)
- **Telescope** — fuzzy finding with fzf-native, flash.nvim integration
- **Python-aware** — virtualenv auto-detection (DAP, venv-selector)

## Requirements

- Neovim >= 0.10
- [Nerd Font](https://www.nerdfonts.com/) (for icons)
- `git`, `ripgrep`, `fd`, `lazygit` (recommended)

## Installation

```bash
git clone git@github.com:mateobaer/config-nvim.git ~/.config/nvim
nvim
```

lazy.nvim auto-installs on first launch. Run `:Lazy sync` to update plugins.

## Structure

```
~/.config/nvim/
  init.lua              # Entry point
  lazy-lock.json        # Pinned plugin commits
  lua/mateo/
    lazy.lua            # lazy.nvim bootstrap
    core/
      init.lua          # Loads options + keymaps
      options.lua       # Neovim options
      keymaps.lua       # Global keymaps
    plugins/            # One file per plugin
    plugins/lsp/
      mason.lua         # Mason setup
      lspconfig.lua     # Language server configs
```

## Keymaps

Leader key: `<Space>`

| Category | Keymaps |
|----------|---------|
| **Splits** | `<leader>sv` (vertical), `<leader>sh` (horizontal), `<leader>sm` (maximize) |
| **Tabs** | `<leader>to` (new), `<leader>tx` (close), `<leader>tn`/`<leader>tp` (next/prev) |
| **Find** | `<leader>ff` (files), `<leader>fr` (recent), `<leader>fs` (grep), `<leader>fb` (buffer) |
| **LSP** | `K` (hover), `gd` (definition), `gr` (references), `<F2>` (rename), `<F4>` (code actions) |
| **Git** | `<leader>hs`/`<leader>hr` (stage/reset hunk), `<leader>hb` (blame), `<leader>lg` (lazygit) |
| **Debug** | `<leader>db` (breakpoint), `<leader>dc` (continue), `<leader>ds` (step over) |
| **Test** | `<leader>rr` (nearest), `<leader>rR` (file), `<leader>ro` (output) |
| **Explorer** | `<leader>ee` (tree), `-` (oil parent), `<leader>eo` (oil explorer) |
| **Diagnostics** | `<leader>xw` (workspace), `<leader>xd` (buffer), `<leader>xt` (todos) |
| **Theme** | `<leader>ut` (themery picker) |
| **Navigation** | `s` (flash jump), `<C-h/j/k/l>` (tmux/nvim splits), `]t`/`[t` (todos) |

## Language Support

### LSP Servers

TypeScript/JavaScript (`ts_ls`), HTML, CSS, Tailwind CSS, Svelte, Lua, GraphQL, Python (pyright), PHP (intelephense), Prisma, Zig, Rust (rust-analyzer), C/C++ (clangd), Go (gopls), Nix (nil_ls), Haskell (hls), JSON, D, C3, Emmet, Templ.

### Formatters

- **prettier** — JS/TS/React/HTML/CSS/JSON/YAML/Markdown/Svelte/GraphQL
- **stylua** — Lua
- **ruff** — Python
- Format on save enabled, LSP fallback.

### Linters

- **eslint_d** — JavaScript/TypeScript/React/Svelte
- **ruff** — Python

## Colorschemes

| Theme | Variants |
|-------|----------|
| Ayu (default) | Mirage, Dark |
| Gruvbox | Dark |
| Tokyo Night | Storm, Moon |
| Monokai | Pro, Soda, Ristretto, base |
| Catppuccin | Mocha, Macchiato |
| Kanagawa | Wave, Dragon |
| Rose Pine | Main, Moon |
| OneDark | Deep |

All themes have transparency enabled. Use `<leader>ut` to open the interactive theme picker.

## Plugins

Key plugins by category:

- **UI**: alpha-nvim, bufferline.nvim, lualine.nvim, noice.nvim, nvim-notify, dressing.nvim, which-key.nvim
- **Editing**: nvim-treesitter, nvim-cmp + LuaSnip, nvim-autopairs, nvim-surround, substitute.nvim, flash.nvim, Comment.nvim
- **Navigation**: telescope.nvim, nvim-tree.lua, oil.nvim, vim-maximizer, vim-tmux-navigator
- **Git**: gitsigns.nvim, lazygit.nvim
- **LSP**: nvim-lspconfig, mason.nvim, mason-lspconfig.nvim, mason-tool-installer.nvim
- **Debug/Test**: nvim-dap, nvim-dap-ui, nvim-dap-python, neotest
- **Quality**: trouble.nvim, todo-comments.nvim, nvim-lint, conform.nvim
- **Other**: auto-session.nvim, venv-selector.nvim, nvim-navic, indent-blankline.nvim, themery.nvim

For the full list with pinned commits, see [`lazy-lock.json`](./lazy-lock.json).
