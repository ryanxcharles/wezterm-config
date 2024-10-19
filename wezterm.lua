local wezterm = require("wezterm")

-- Reload config: cmd+shift+r

local window_is_active = true -- Track window active status

wezterm.on("window-focus-changed", function(window, pane)
  if window:is_focused() then
    -- Window is focused, restore normal settings
    window:set_config_overrides({
      window_background_opacity = 1.0,  -- Restore normal opacity
      colors = {
        tab_bar = {
          active_tab = {
            bg_color = "#FF9800",  -- Bright orange when window is active
            fg_color = "#FFFFFF",  -- White text
          },
        },
      },
    })
  else
    -- Window is not focused, change active tab to "great" (gray-like) color
    window:set_config_overrides({
      window_background_opacity = 0.5,  -- Set dimmed opacity
      colors = {
        tab_bar = {
          active_tab = {
            bg_color = "#808080",  -- Gray color for the active tab when window is inactive
            fg_color = "#D3D3D3",  -- Light gray text
          },
        },
      },
    })
  end
end)

return {
	-- Set up custom keybindings
	keys = {
		-- New tab: cmd+t
		{ key = "t", mods = "CMD", action = wezterm.action({ SpawnTab = "DefaultDomain" }) },

		-- Move right one tab: ctrl+shift+r
		{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = 1 }) },

		-- Move left one tab: ctrl+shift+l
		{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },

		-- Split vertical: cmd+v
		{ key = "j", mods = "CMD", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

		-- Split vertical: cmd+v
		{ key = "l", mods = "CMD", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },

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
			key = "h",
			mods = "CTRL|ALT",
			action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
		},

		-- Resize the current pane right: ctrl+alt+l
		{
			key = "l",
			mods = "CTRL|ALT",
			action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
		},

		-- Resize the current pane up: ctrl+alt+k
		{
			key = "k",
			mods = "CTRL|ALT",
			action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
		},

		-- Resize the current pane down: ctrl+alt+j
		{
			key = "j",
			mods = "CTRL|ALT",
			action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
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
	},

	font_size = 11,

colors = {
  -- Brighter foreground and background for better contrast
  foreground = "#ECEFF4",  -- Brighter white for text
  background = "#1E1F29",  -- Darker background for better contrast

  -- More vibrant cursor colors
  cursor_bg = "#FF9800",    -- Brighter orange for the cursor
  cursor_border = "#FF9800",  -- Match cursor border with cursor color
  cursor_fg = "#FFFFFF",    -- Keep white for better contrast

  -- Brighter selection colors
  selection_bg = "#5C6B88",  -- Slightly brighter selection background
  selection_fg = "#ECEFF4",  -- Brighter text when selected

  -- More vibrant ANSI colors
  ansi = {
    "#3B4252",  -- Black (no change)
    "#FF5555",  -- Red (brighter, more vibrant)
    "#A3BE8C",  -- Green (slightly adjusted)
    "#F0C674",  -- Yellow (brighter, more saturated)
    "#81A1C1",  -- Blue (slightly more saturated)
    "#D087C2",  -- Magenta (more vibrant)
    "#8ABEB7",  -- Cyan (slightly more bold)
    "#ECEFF4",  -- White (brighter)
  },

  brights = {
    "#4C566A",  -- Bright black (dimmed)
    "#FF6E6E",  -- Bright red (more vibrant)
    "#A3BE8C",  -- Bright green (slightly adjusted)
    "#FFD580",  -- Bright yellow (more vibrant)
    "#81A1C1",  -- Bright blue (slightly adjusted)
    "#D8A0E5",  -- Bright magenta (brighter, more vibrant)
    "#8AEAEA",  -- Bright cyan (bolder)
    "#FFFFFF",  -- Bright white (pure white)
  },

  -- Enhanced tab bar colors for clarity
  tab_bar = {
    active_tab = {
      bg_color = "#FF9800",  -- Bold orange for active tab background
      fg_color = "#FFFFFF",  -- White text for active tab
    },
    inactive_tab = {
      bg_color = "#3B4252",  -- Darker background for inactive tabs
      fg_color = "#888C99",  -- Dimmed text for inactive tabs
    },
    inactive_pane_edge = "#FF9800",  -- Match the active tab highlight
  },
},

	-- Window background opacity setting for dimming
	window_background_opacity = 1.0, -- Set the default active window opacity
	inactive_window_opacity = 0.7, -- Set the opacity when the window is inactive

	-- Dim inactive panes to make the active one stand out
	inactive_pane_hsb = {
		hue = 1.0, -- Keep the hue the same
		saturation = 0.7, -- Reduce saturation for inactive panes
		brightness = 0.5, -- Make inactive panes slightly dimmer
	},
}
