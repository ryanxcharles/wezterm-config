local wezterm = require("wezterm")

-- Reload config: cmd+shift+r

local window_is_active = true -- Track window active status

wezterm.on("window-focus-changed", function(window, pane)
	if window:is_focused() then
		-- Window is focused, make it fully opaque
		window:set_config_overrides({
			window_background_opacity = 1.0,
		})
		window_is_active = true
	else
		-- Window is not focused, dim the background
		window:set_config_overrides({
			window_background_opacity = 0.7, -- Set dimmed opacity
		})
		window_is_active = false
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
		{ key = "h", mods = "CMD", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },

		-- Move right one window (rotate right): ctrl+r
		{ key = "l", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

		-- Move left one window (rotate left): ctrl+l
		{ key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	},

	colors = {
		foreground = "#D8DEE9",
		background = "#2E3440",
		cursor_bg = "#FA8603",
		cursor_border = "#FA8603",
		cursor_fg = "#FFFFFF",
		selection_bg = "#434C5E",
		selection_fg = "#D8DEE9",

		ansi = { "#3B4252", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#88C0D0", "#E5E9F0" },
		brights = { "#4C566A", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#8FBCBB", "#ECEFF4" },

		tab_bar = {
			active_tab = {
				bg_color = "#4C566A", -- Change to a highlighted background color for active tab
				fg_color = "#ECEFF4", -- Change to a highlighted text color for active tab
			},
			inactive_tab = {
				bg_color = "#3B4252", -- Dimmer color for inactive tabs
				fg_color = "#D8DEE9", -- Keep text in inactive tabs dimmer
			},
			inactive_pane_edge = "#4C566A", -- Color the edge/border of inactive panes
		},

		-- Dim inactive panes to make the active one stand out
		-- inactive_pane = {
		-- 	hue = 1.0, -- Keep the hue the same
		-- 	saturation = 0.7, -- Reduce saturation for inactive panes
		-- 	brightness = 0.3, -- Make inactive panes slightly dimmer
		-- },
	},

	-- Window background opacity setting for dimming
	window_background_opacity = 1.0, -- Set the default active window opacity
	inactive_window_opacity = 0.7, -- Set the opacity when the window is inactive
}
