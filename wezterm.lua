local wezterm = require("wezterm")

-- Reload config: cmd+r

local config = {
  -- Set up custom keybindings
  keys = {
    -- Close the current pane (with confirmation prompt to avoid accidents)
    {
      key = "q", -- Change this to any key you prefer (e.g., 'k' for "kill")
      mods = "CTRL|SHIFT", -- Ctrl+Shift+Q
      action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },

    -- New tab: cmd+t
    { key = "t", mods = "CMD", action = wezterm.action({ SpawnTab = "DefaultDomain" }) },

    -- Move right one tab: ctrl+shift+r
    { key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = 1 }) },

    -- Move left one tab: ctrl+shift+l
    { key = "h", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },

    -- Split right shortcut
    {
      key = ";",
      mods = "CMD",
      action = wezterm.action.SplitPane({
        direction = "Left",
        size = { Percent = 20 },
      }),
    },

    -- Split vertical down: cmd+j
    { key = "j", mods = "CMD", action = wezterm.action.SplitPane({ direction = "Down" }) },

    -- Split vertical up: cmd+k
    { key = "k", mods = "CMD", action = wezterm.action.SplitPane({ direction = "Up" }) },

    -- Split horizontal right: cmd+l
    { key = "l", mods = "CMD", action = wezterm.action.SplitPane({ direction = "Right" }) },

    -- Split horizontal left: cmd+h
    { key = "h", mods = "CMD", action = wezterm.action.SplitPane({ direction = "Left" }) },

    -- Move right one window (rotate right): ctrl+r
    { key = "l", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

    -- Move left one window (rotate left): ctrl+l
    { key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },

    -- Move up one window (rotate up): ctrl+k
    { key = "k", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },

    -- Move down one window (rotate down): ctrl+j
    { key = "j", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },

    -- Resize the current pane left: ctrl+alt+h
    {
      key = "LeftArrow",
      mods = "CTRL|ALT",
      action = wezterm.action.AdjustPaneSize({ "Left", 10 }),
    },

    -- Resize the current pane right: ctrl+alt+l
    {
      key = "RightArrow",
      mods = "CTRL|ALT",
      action = wezterm.action.AdjustPaneSize({ "Right", 10 }),
    },

    -- Resize the current pane up: ctrl+alt+k
    {
      key = "UpArrow",
      mods = "CTRL|ALT",
      action = wezterm.action.AdjustPaneSize({ "Up", 10 }),
    },

    -- Resize the current pane down: ctrl+alt+j
    {
      key = "DownArrow",
      mods = "CTRL|ALT",
      action = wezterm.action.AdjustPaneSize({ "Down", 10 }),
    },

    -- Rename tab: ctrl+shift+t
    {
      key = "t",
      mods = "CTRL|SHIFT",
      action = wezterm.action.PromptInputLine({
        description = "Enter new name for tab",
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },

    -- Move tab to the left: ctrl+shift+left
    {
      key = "LeftArrow",
      mods = "CTRL|SHIFT",
      action = wezterm.action.MoveTabRelative(-1),
    },

    -- Move tab to the right: ctrl+shift+right
    {
      key = "RightArrow",
      mods = "CTRL|SHIFT",
      action = wezterm.action.MoveTabRelative(1),
    },

    -- Zoom: focus on the current pane and hide the others
    {
      key = "Z",
      mods = "CTRL|SHIFT",
      action = wezterm.action.TogglePaneZoomState,
    },
  },

  font_size = 11,

  -- colors = config_colors_active,
  -- color_scheme = "Tokyo Night Storm",
  color_scheme = "Catppuccin Mocha",
  colors = {
    cursor_bg = "#FA8603",
    cursor_fg = "#FFFFFF",
    background = "#222435",
    tab_bar = {
      background = "#222435",
      active_tab = {
        bg_color = "#5f87af", -- Change to a highlighted background color for active tab
        fg_color = "#FFFFFF", -- Change to a highlighted text color for active tab
      },
      inactive_tab = {
        bg_color = "#222435", -- Dimmer color for inactive tabs
        fg_color = "#D8DEE9", -- Keep text in inactive tabs dimmer
      },
      new_tab = {
        bg_color = "#222435", -- Slight blue-gray background for the new tab button
        fg_color = "#D8DEE9", -- Light gray text color for the new tab button
      },
      new_tab_hover = {
        bg_color = "#5f87af", -- Bright blue-gray when hovering over the new tab button
        fg_color = "#FFFFFF", -- White text when hovering
      },
      inactive_tab_hover = {
        bg_color = "#5f87af", -- Same color as the active tab background
        fg_color = "#FFFFFF", -- Same text color as active tab
      },
    },
  },

  use_fancy_tab_bar = true,

  -- Window background opacity setting for dimming
  window_background_opacity = 1.0, -- Set the default active window opacity

  -- Remove title bar, but keep resize borders
  window_decorations = "RESIZE",

  -- Dim inactive panes to make the active one stand out
  inactive_pane_hsb = {
    hue = 1.0, -- Keep the hue the same
    saturation = 0.7, -- Reduce saturation for inactive panes
    brightness = 0.5, -- Make inactive panes slightly dimmer
  },

  window_frame = {
    -- Titlebar colors
    inactive_titlebar_bg = "#222435", -- Matches inactive tab background
    active_titlebar_bg = "#222435", -- Matches window background
    inactive_titlebar_fg = "#D8DEE9", -- Matches dimmed foreground for inactive tabs
    active_titlebar_fg = "#FFFFFF", -- Matches bright foreground for active tabs

    -- Titlebar border colors
    inactive_titlebar_border_bottom = "#434C5E", -- Matches selection background (subtle border)
    active_titlebar_border_bottom = "#5f87af", -- Matches active tab background (highlighted)

    -- Button colors (for minimize, maximize, close)
    button_fg = "#D8DEE9", -- Matches dimmed foreground
    button_bg = "#2E3440", -- Matches background
    button_hover_fg = "#FFFFFF", -- Brighter text when hovering
    button_hover_bg = "#5f87af", -- Matches active tab background when hovering
  },

  -- disable nushell for now
  default_prog = {
    "env",
    "XDG_CONFIG_HOME=/Users/ryan/.config",
    "/opt/homebrew/bin/nu",
    "--login",
  },
}

return config
