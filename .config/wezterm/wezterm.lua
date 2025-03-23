local wezterm = require("wezterm")

return {
  -- Set Tokyo Night color scheme
  color_scheme = "Tokyo Night",

  -- Remove padding
  window_padding = {
    left = 0, right = 0, top = 0, bottom = 0,
  },

  -- Enable Right-to-Left (RTL) support الحمد لله
  bidi_enabled = true,

  -- Cursor settings (white block)
  -- default_cursor_style = "Block",
  cursor_blink_rate = 500,
  colors = {
    cursor_fg = '#1a1b26',
    cursor_bg = '#a9b1d6',
  },

  -- Hide all UI elements
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "NONE",
  enable_scroll_bar = false,

  -- Font settings
  font_size = 11,
  -- font = wezterm.font("JetBrainsMonoNerdFont"),
}
