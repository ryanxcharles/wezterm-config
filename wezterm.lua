local wezterm = require("wezterm")

-- Reload config: cmd+shift+r

-- local window_is_active = true -- Track window active status

local activeWindowColors = {
	foreground = "#D8DEE9",
	background = "#2E3440",
	cursor_bg = "#FA8603",
	cursor_border = "#FA8603",
	cursor_fg = "#FFFFFF",
	selection_bg = "#434C5E",
	selection_fg = "#D8DEE9",

	ansi = {
		"#3B4252", -- Black
		"#BF616A", -- Red
		"#A3BE8C", -- Green
		"#EBCB8B", -- Yellow
		"#81A1C1", -- Blue
		"#B48EAD", -- Magenta
		"#88C0D0", -- Cyan
		"#E5E9F0", -- White (Light Gray)
	},
	brights = {
		"#4C566A", -- Bright Black (Gray)
		"#BF616A", -- Bright Red
		"#A3BE8C", -- Bright Green
		"#EBCB8B", -- Bright Yellow
		"#81A1C1", -- Bright Blue
		"#B48EAD", -- Bright Magenta
		"#8FBCBB", -- Bright Cyan
		"#ECEFF4", -- Bright White (Pure White)
	},

	tab_bar = {
		background = "#000000",
		active_tab = {
			bg_color = "#5191E1", -- Change to a highlighted background color for active tab
			fg_color = "#ECEFF4", -- Change to a highlighted text color for active tab
		},
		inactive_tab = {
			bg_color = "#3B4252", -- Dimmer color for inactive tabs
			fg_color = "#D8DEE9", -- Keep text in inactive tabs dimmer
		},
	},
}

local inactiveWindowColors = {
	foreground = "#C6CCD2", -- Desaturated foreground
	background = "#2B3038", -- Slightly darker, less vibrant background
	cursor_bg = "#C6CCD2", -- Desaturated cursor background
	cursor_border = "#C6CCD2", -- Match cursor background with border
	cursor_fg = "#2B3038", -- Adjusted cursor foreground
	selection_bg = "#3F4855", -- Less saturated selection background
	selection_fg = "#C6CCD2", -- Desaturated selection foreground

	ansi = {
		"#343B45", -- Desaturated black
		"#B05858", -- Desaturated red
		"#8DAA85", -- Desaturated green
		"#C3A45B", -- Desaturated yellow
		"#6B829C", -- Desaturated blue
		"#A47A9F", -- Desaturated magenta
		"#7B9A98", -- Desaturated cyan
		"#C8D1DA", -- Desaturated white
	},

	brights = {
		"#49505A", -- Desaturated bright black
		"#B05858", -- Desaturated bright red (similar to non-bright)
		"#8DAA85", -- Desaturated bright green
		"#C3A45B", -- Desaturated bright yellow
		"#6B829C", -- Desaturated bright blue
		"#A47A9F", -- Desaturated bright magenta
		"#7B9A98", -- Desaturated bright cyan
		"#D1DBE1", -- Desaturated bright white
	},

	tab_bar = {
		background = "#000000",
		active_tab = {
			bg_color = "#707070", -- Slightly darker gray for the active tab
			fg_color = "#C0C0C0", -- Desaturated light gray for the active tab text
		},
		inactive_tab = {
			bg_color = "#343B45", -- Desaturated background for inactive tabs
			fg_color = "#C6CCD2", -- Desaturated text for inactive tabs
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
