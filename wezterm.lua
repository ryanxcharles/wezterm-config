local wezterm = require("wezterm")

-- Reload config: cmd+shift+r

-- local window_is_active = true -- Track window active status

local activeWindowColors = {
	-- Nord theme
	foreground = "#D8DEE9",
	background = "#2E3440",
	cursor_bg = "#D8DEE9",
	cursor_border = "#D8DEE9",
	cursor_fg = "#2E3440",
	selection_bg = "#434C5E",
	selection_fg = "#D8DEE9",

	ansi = { "#3B4252", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#88C0D0", "#E5E9F0" },
	brights = { "#4C566A", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#8FBCBB", "#ECEFF4" },

	tab_bar = {
		active_tab = {
			bg_color = "#33669A", -- Change to a highlighted background color for active tab
			fg_color = "#ECEFF4", -- Change to a highlighted text color for active tab
		},
		inactive_tab = {
			bg_color = "#3B4252", -- Dimmer color for inactive tabs
			fg_color = "#D8DEE9", -- Keep text in inactive tabs dimmer
		},
	},
}

local inactiveWindowColors = {
	-- Nord theme
	foreground = "#D8DEE9",
	background = "#2E3440",
	cursor_bg = "#D8DEE9",
	cursor_border = "#D8DEE9",
	cursor_fg = "#2E3440",
	selection_bg = "#434C5E",
	selection_fg = "#D8DEE9",

	ansi = { "#3B4252", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#88C0D0", "#E5E9F0" },
	brights = { "#4C566A", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#8FBCBB", "#ECEFF4" },

	tab_bar = {
		active_tab = {
			bg_color = "#808080", -- Gray color for the active tab when window is inactive
			fg_color = "#D3D3D3", -- Light gray text
		},
		inactive_tab = {
			bg_color = "#3B4252", -- Dimmer color for inactive tabs
			fg_color = "#D8DEE9", -- Keep text in inactive tabs dimmer
		},
	},
}

wezterm.on("window-focus-changed", function(window, pane)
	if window:is_focused() then
		-- Window is focused, restore normal settings
		window:set_config_overrides({
			window_background_opacity = 1.0, -- Restore normal opacity
			colors = activeWindowColors,
		})
	else
		-- Window is not focused, change active tab to "great" (gray-like) color
		window:set_config_overrides({
			window_background_opacity = 0.8, -- Set dimmed opacity
			-- colors = activeWindowColors,
			colors = inactiveWindowColors,
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

	colors = activeWindowColors,

	-- Window background opacity setting for dimming
	window_background_opacity = 1.0, -- Set the default active window opacity

	-- Dim inactive panes to make the active one stand out
	inactive_pane_hsb = {
		hue = 1.0, -- Keep the hue the same
		saturation = 0.7, -- Reduce saturation for inactive panes
		brightness = 0.5, -- Make inactive panes slightly dimmer
	},
}
