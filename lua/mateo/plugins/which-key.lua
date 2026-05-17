local function to_hex(color)
  if not color then
    return nil
  end

  return string.format("#%06x", color)
end

local function hex_to_rgb(color)
  if not color then
    return nil
  end

  color = color:gsub("#", "")
  return {
    r = tonumber(color:sub(1, 2), 16),
    g = tonumber(color:sub(3, 4), 16),
    b = tonumber(color:sub(5, 6), 16),
  }
end

local function blend(fg, bg, alpha)
  local fg_rgb = hex_to_rgb(fg)
  local bg_rgb = hex_to_rgb(bg)

  if not fg_rgb or not bg_rgb then
    return fg or bg
  end

  local function channel(foreground, background)
    return math.floor((alpha * foreground) + ((1 - alpha) * background) + 0.5)
  end

  return string.format(
    "#%02x%02x%02x",
    channel(fg_rgb.r, bg_rgb.r),
    channel(fg_rgb.g, bg_rgb.g),
    channel(fg_rgb.b, bg_rgb.b)
  )
end

local function get_hl(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok then
    return {}
  end

  return hl
end

local function patch_title_trail()
  local view = require("which-key.view")

  if view._mateo_title_patch then
    return
  end

  function view.trail(node, opts)
    opts = opts or {}

    local function hl(group)
      return opts.title and "WhichKeyTitle" or (group and ("WhichKey" .. group) or "WhichKeyGroup")
    end

    local trail = {}
    local did_op = false

    while node do
      local desc

      if node.desc then
        local label = require("which-key.view").replace("desc", node.desc)
        if opts.title then
          desc = label
        else
          desc = require("which-key.config").icons.group .. label
        end
      elseif node.key then
        desc = require("which-key.view").replace("key", node.key)
      else
        desc = ""
      end

      node = node.parent

      if desc ~= "" then
        if node and #trail > 0 then
          table.insert(trail, 1, { " " .. require("which-key.config").icons.breadcrumb .. " ", hl("Separator") })
        end
        table.insert(trail, 1, { desc, hl() })
      end

      local state = require("which-key.state").state
      local mode = state and state.mode and state.mode.mode or nil
      if not did_op and not node and (mode == "x" or mode == "o") then
        did_op = true
        local buf = require("which-key.buf").get({ buf = state.mode.buf.buf, mode = "n" })
        if buf then
          node = buf.tree:find(mode == "x" and "v" or vim.v.operator)
        end
      end
    end

    if #trail > 0 then
      table.insert(trail, 1, { " ", hl() })
      table.insert(trail, { " ", hl() })
      return trail
    end
  end

  view._mateo_title_patch = true
end

local function set_which_key_highlights()
  local normal = get_hl("Normal")
  local normal_float = get_hl("NormalFloat")
  local float_border = get_hl("FloatBorder")
  local title = get_hl("Title")
  local comment = get_hl("Comment")
  local keyword = get_hl("Keyword")
  local identifier = get_hl("Identifier")
  local special = get_hl("Special")
  local visual = get_hl("Visual")
  local constant = get_hl("Constant")

  local background = to_hex(normal.bg)
    or to_hex(normal_float.bg)
    or (vim.o.background == "light" and "#eef1f4" or "#161821")
  local foreground = to_hex(normal.fg)
    or to_hex(normal_float.fg)
    or (vim.o.background == "light" and "#243746" or "#d8dee9")
  local border_fg = to_hex(float_border.fg)
    or to_hex(title.fg)
    or to_hex(identifier.fg)
    or foreground
  local group_fg = to_hex(keyword.fg) or border_fg
  local icon_fg = to_hex(special.fg) or group_fg
  local key_fg = to_hex(constant.fg) or blend(border_fg, foreground, 0.55)
  local muted_fg = to_hex(comment.fg) or blend(foreground, background, 0.62)
  local tinted_bg = to_hex(normal_float.bg) or blend(foreground, background, 0.08)
  local border_bg = blend(border_fg, background, 0.09)
  local title_bg = blend(border_fg, background, 0.2)
  local accent_bg = to_hex(visual.bg) or blend(border_fg, background, 0.12)
  local key_bg = blend(border_fg, background, 0.14)

  vim.api.nvim_set_hl(0, "WhichKey", { fg = key_fg, bg = tinted_bg, bold = true })
  vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = foreground, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = group_fg, bg = tinted_bg, bold = true })
  vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = muted_fg, bg = tinted_bg, italic = true })
  vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = muted_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = border_fg, bg = border_bg })
  vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = foreground, bg = title_bg, bold = true })
  vim.api.nvim_set_hl(0, "WhichKeyNormal", { bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyKey", { fg = key_fg, bg = key_bg, bold = true })
  vim.api.nvim_set_hl(0, "WhichKeyIcon", { fg = icon_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconAzure", { fg = icon_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconBlue", { fg = icon_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconCyan", { fg = icon_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconGreen", { fg = icon_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconGrey", { fg = muted_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconOrange", { fg = icon_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconPurple", { fg = group_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconRed", { fg = border_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyIconYellow", { fg = icon_fg, bg = tinted_bg })
  vim.api.nvim_set_hl(0, "WhichKeyBackdrop", { bg = accent_bg })
end

local function register_groups()
  local wk = require("which-key")

  wk.add({
    { "<leader>d", group = "Debug", icon = { icon = "", color = "red" } },
    { "<leader>e", group = "Explorer", icon = { icon = "", color = "yellow" } },
    { "<leader>f", group = "Find", icon = { icon = "󰍉", color = "blue" } },
    { "<leader>h", group = "Git Hunks", icon = { icon = "󰊢", color = "orange" } },
    { "<leader>m", group = "Format", icon = { icon = "󰉼", color = "green" } },
    { "<leader>r", group = "Run / Tests", icon = { icon = "󰜎", color = "green" } },
    { "<leader>s", group = "Splits", icon = { icon = "󰖲", color = "cyan" } },
    { "<leader>t", group = "Tabs", icon = { icon = "󰓩", color = "purple" } },
    { "<leader>u", group = "Theme / UI", icon = { icon = "󰔎", color = "purple" } },
    { "<leader>v", group = "Virtual Env", icon = { icon = "", color = "green" } },
    { "<leader>w", group = "Workspace", icon = { icon = "󱂬", color = "blue" } },
    { "<leader>x", group = "Diagnostics", icon = { icon = "", color = "orange" } },
    { "<leader>ee", desc = "Toggle explorer", icon = { icon = "", color = "yellow" } },
    { "<leader>ef", desc = "Reveal current file", icon = { icon = "󰈔", color = "yellow" } },
    { "<leader>ec", desc = "Collapse explorer", icon = { icon = "󰅖", color = "yellow" } },
    { "<leader>er", desc = "Refresh explorer", icon = { icon = "󰑐", color = "yellow" } },
    { "<leader>eo", desc = "Open oil explorer", icon = { icon = "󰏇", color = "yellow" } },
    { "<leader>eO", desc = "Open floating oil", icon = { icon = "󰀿", color = "yellow" } },
    { "<leader>ff", desc = "Find files", icon = { icon = "󰱼", color = "blue" } },
    { "<leader>fr", desc = "Recent files", icon = { icon = "󰋚", color = "blue" } },
    { "<leader>fs", desc = "Live grep", icon = { icon = "󰍉", color = "blue" } },
    { "<leader>fc", desc = "Word under cursor", icon = { icon = "󰱽", color = "blue" } },
    { "<leader>fb", desc = "Buffer search", icon = { icon = "󰈔", color = "blue" } },
    { "<leader>ft", desc = "Find todos", icon = { icon = "󰘦", color = "blue" } },
    { "<leader>lg", desc = "Open lazygit", icon = { icon = "", color = "orange" } },
    { "<leader>xw", desc = "Workspace diagnostics", icon = { icon = "", color = "orange" } },
    { "<leader>xd", desc = "Buffer diagnostics", icon = { icon = "󰅚", color = "orange" } },
    { "<leader>xq", desc = "Quickfix list", icon = { icon = "󰁨", color = "orange" } },
    { "<leader>xl", desc = "Location list", icon = { icon = "󰍍", color = "orange" } },
    { "<leader>xt", desc = "Todo list", icon = { icon = "󰘦", color = "orange" } },
    { "<leader>to", desc = "Open new tab", icon = { icon = "󰓩", color = "purple" } },
    { "<leader>tx", desc = "Close tab", icon = { icon = "󰅙", color = "purple" } },
    { "<leader>tn", desc = "Next tab", icon = { icon = "󰒭", color = "purple" } },
    { "<leader>tp", desc = "Previous tab", icon = { icon = "󰒮", color = "purple" } },
    { "<leader>tf", desc = "Buffer in new tab", icon = { icon = "󰈔", color = "purple" } },
    { "<leader>rp", desc = "Run Python file", icon = { icon = "󰌠", color = "green" } },
    { "<leader>rr", desc = "Run nearest test", icon = { icon = "󰙨", color = "green" } },
    { "<leader>rR", desc = "Run file tests", icon = { icon = "󰙨", color = "green" } },
    { "<leader>rs", desc = "Stop test", icon = { icon = "󰓛", color = "green" } },
    { "<leader>ro", desc = "Test output", icon = { icon = "󰆍", color = "green" } },
    { "<leader>rt", desc = "Toggle test summary", icon = { icon = "󰙅", color = "green" } },
    { "<leader>ut", desc = "Open theme picker", icon = { icon = "󰸌", color = "purple" } },
    { "<leader>un", desc = "Message history", icon = { icon = "󰍡", color = "purple" } },
    { "<leader>ul", desc = "Last message", icon = { icon = "󰎞", color = "purple" } },
  })
end

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    delay = 300,
    preset = "modern",
    win = {
      border = "rounded",
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      zindex = 1000,
      wo = {
        winblend = 8,
      },
    },
    layout = {
      width = { min = 28, max = 48 },
      spacing = 4,
    },
    icons = {
      breadcrumb = "›",
      separator = "󰄾 ",
      group = " ",
      mappings = true,
      keys = {
        Up = " ",
        Down = " ",
        Left = " ",
        Right = " ",
        C = "󰘴 ",
        M = "󰘵 ",
        D = "󰘳 ",
        S = "󰘶 ",
        CR = "󰌑 ",
        Esc = "󱊷 ",
        BS = "󰁮 ",
        Space = "󱁐 ",
        Tab = "󰌒 ",
      },
    },
    show_help = true,
    show_keys = true,
    sort = { "group", "alphanum", "local", "order" },
    expand = 1,
  },
  config = function(_, opts)
    require("which-key").setup(opts)
    patch_title_trail()
    register_groups()
    set_which_key_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("mateo.which_key_theme", { clear = true }),
      callback = set_which_key_highlights,
    })
  end,
}
