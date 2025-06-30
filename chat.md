in wezterm, i have some key bindings set up. now, i can open a new window to the
right with `CMD+l`. however, i really want it to open the new window with a
fixed wize of 120 columns. is that possible?

```lua
return {
  -- Set up custom keybindings
  keys = {
    -- New tab: cmd+t
    { key = "t", mods = "CMD", action = wezterm.action({ SpawnTab = "DefaultDomain" }) },

    -- Move right one tab: ctrl+shift+r
    { key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = 1 }) },

    -- Move left one tab: ctrl+shift+l
    { key = "h", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },

    -- Split vertical down: cmd+j
    { key = "j", mods = "CMD", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

    -- Split vertical up: cmd+k
    { key = "k", mods = "CMD", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

    -- Split horizontal right: cmd+l
    { key = "l", mods = "CMD", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },

    -- Split horizontal left: cmd+h
    { key = "h", mods = "CMD", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },

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

    -- Zoom: focus on the current pane and hide the others
    {
      key = "Z",
      mods = "CTRL|SHIFT",
      action = wezterm.action.TogglePaneZoomState,
    },
  },

  font_size = 11,

  colors = config_colors_active,

  -- Window background opacity setting for dimming
  window_background_opacity = 1.0, -- Set the default active window opacity

  -- Dim inactive panes to make the active one stand out
  inactive_pane_hsb = {
    hue = 1.0, -- Keep the hue the same
    saturation = 0.7, -- Reduce saturation for inactive panes
    brightness = 0.5, -- Make inactive panes slightly dimmer
  },

  window_frame = config_window_frame_active,

  -- disable nushell for now
  -- default_prog = {
  --   "env",
  --   "XDG_CONFIG_HOME=/Users/ryan/.config",
  --   "/opt/homebrew/bin/nu",
  --   "--login",
  -- },
}
```

# === ASSISTANT ===

Yes, it is possible to open a new pane with a fixed width in WezTerm, but
unfortunately, the `SplitHorizontal` action does not directly support setting a
specific size (like 120 columns) when splitting. However, you can achieve this
by using a custom action with a combination of `SplitHorizontal` and
`AdjustPaneSize` or by leveraging WezTerm's event system to resize the pane
after it's created. Here's how you can approach it.

### Solution: Use a Custom Callback to Resize After Splitting

WezTerm allows you to use `action_callback` to run custom logic after an action.
You can split the pane horizontally with `CMD+l` and then immediately resize the
new pane to a specific width (approximating 120 columns). Since WezTerm's
`AdjustPaneSize` works in cells (not columns directly), you'll need to estimate
the number of cells that correspond to 120 columns based on your font size and
window size, or use a fixed cell width if your setup is consistent.

Here's how you can modify your keybinding for `CMD+l` to split horizontally and
attempt to set the new pane to a specific width:

```lua
return {
  keys = {
    -- Other keybindings remain the same...

    -- Split horizontal right: cmd+l (with fixed width approximation)
    {
      key = "l",
      mods = "CMD",
      action = wezterm.action_callback(function(window, pane)
        -- Perform the horizontal split
        local new_pane = pane:split({ direction = "Right", domain = "CurrentPaneDomain" })
        -- Optionally, activate the new pane if desired
        window:perform_action(wezterm.action.ActivatePane(new_pane:pane_id()), pane)
        -- Attempt to resize the new pane (adjust the number of cells as needed)
        -- Note: This is an approximation since exact column width depends on font size
        window:perform_action(wezterm.action.AdjustPaneSize({ "Left", 60 }), new_pane)
      end),
    },

    -- Other keybindings...
  },

  -- Other configurations...
}
```

### Explanation:

1. **`pane:split`**:
   - This creates a new pane to the right of the current pane (horizontal
     split).
   - The `direction = "Right"` argument specifies the split direction.

2. **`window:perform_action`**:
   - After splitting, you can activate the new pane (optional, if you want focus
     to move to the new pane).
   - Then, `AdjustPaneSize` is used to resize the pane. Here, `"Left", 60` is a
     rough guess to shrink or expand the pane to approximate 120 columns. You'll
     need to tweak this value based on your font size and display settings since
     WezTerm uses "cells" for sizing, not exact column counts.

3. **Why Approximation?**:
   - WezTerm does not provide a direct way to set pane size in terms of columns
     because the actual width of a column depends on the font, font size, and
     display scaling. You may need to experiment with the `AdjustPaneSize` value
     (e.g., `60` cells) to get close to 120 columns in your setup.

### Alternative: Listen for Pane Creation Events

If the above approximation doesn't work well, you can listen for pane creation
events using WezTerm's event system and resize the pane after it's created.
However, this is more complex and requires tracking pane IDs or using timers to
ensure the resize happens after the split. Here's a basic example:

```lua
wezterm.on("update-right-status", function(window, pane)
  -- This is just a placeholder; you can use other events or logic to detect new panes
  -- and resize them if needed.
end)
```

For simplicity, the first approach (using `action_callback`) is recommended
unless you need very precise control.

### Notes:

- **Testing the Size**: After applying the keybinding, test with `CMD+l` and see
  if the new pane's width is close to 120 columns. Adjust the `AdjustPaneSize`
  value (e.g., change `60` to a higher or lower number) to fine-tune the width.
- **Font Size Impact**: If you change your `font_size` or display scaling, the
  number of cells corresponding to 120 columns will change, so you might need to
  recalibrate.
- **Future Updates**: Check WezTerm's documentation or GitHub issues for
  updates, as future versions might add direct support for setting pane sizes in
  columns or percentages.

If you need further assistance with fine-tuning or a more advanced event-based

# === USER ===

is there any way to just set the width of the current pane to 120 columns
directly?

# === ASSISTANT ===

Unfortunately, WezTerm does not currently provide a direct way to set the width
of a pane to a specific number of columns (like 120 columns) because pane sizing
is handled in terms of "cells" or relative proportions, and the actual width of
a column depends on factors like font size, font family, and display scaling.
However, you can approximate setting the current pane's width to 120 columns by
using the `AdjustPaneSize` action or by calculating the necessary cell count
based on your setup.

Below, I'll outline the closest approaches to achieve this in WezTerm as of the
current version (based on documentation and community resources up to October
2023). If a more direct method becomes available in future updates, it would
likely be reflected in the WezTerm documentation.

### Approach 1: Approximate Width Using `AdjustPaneSize`

You can use the `AdjustPaneSize` action to resize the current pane by a certain
number of cells, approximating the width to 120 columns. Since the exact number
of cells per column depends on your font and display settings, you'll need to
experiment with the values.

Here's how you can set up a keybinding to resize the current pane:

```lua
return {
  keys = {
    -- Other keybindings...

    -- Resize current pane to approximate 120 columns (adjust value as needed)
    {
      key = "w",
      mods = "CMD|SHIFT", -- Example keybinding, e.g., CMD+SHIFT+W
      action = wezterm.action_callback(function(window, pane)
        -- This is a rough approximation; adjust the number of cells based on your setup
        -- For example, if 60 cells ≈ 120 columns in your font size, use that
        window:perform_action(wezterm.action.AdjustPaneSize({ "Right", 60 }), pane)
        -- You may also need to adjust "Left" if the pane is on the right side of a split
      end),
    },

    -- Other keybindings...
  },

  -- Other configurations...
}
```

#### Steps to Fine-Tune:

1. **Test the Width**: Bind the action to a key (e.g., `CMD+SHIFT+W`) and press
   it to resize the pane.
2. **Check Column Count**: Run a command like `tput cols` in the terminal to see
   the actual number of columns in the resized pane.
3. **Adjust the Value**: Modify the number in `AdjustPaneSize({ "Right", 60 })`
   (e.g., increase or decrease `60`) until the pane width is close to 120
   columns.
4. **Account for Pane Position**: If the pane is on the right side of a split,
   you might need to use `"Left"` instead of `"Right"` to adjust the size
   correctly.

#### Limitations:

- This is an approximation because WezTerm doesn't map cells directly to columns
  in a configurable way.
- Changing `font_size` or display scaling (e.g., on a different monitor) will
  affect how many cells correspond to 120 columns, requiring recalibration.

### Approach 2: Use `SpawnCommand` or Scripts to Calculate Columns (Advanced)

WezTerm doesn't natively support setting pane width by columns, but you can use
a script or a spawned command to query the current terminal dimensions and
attempt to adjust the pane size dynamically. This is more complex and still
relies on approximations, but it can be more precise if you know your font's
character width.

Here's a conceptual outline:

1. **Query Terminal Size**: Use a command like `tput cols` or `stty size` to get
   the current number of columns in the pane.
2. **Calculate Adjustment**: Compare the current width to 120 columns and
   calculate how many cells to adjust.
3. **Apply Adjustment**: Use `AdjustPaneSize` via a custom action.

However, since WezTerm's Lua API doesn't directly expose a way to read the
current pane's column count or dynamically adjust based on runtime data within
the callback, this approach often requires external scripting or manual
tweaking. You can trigger a script via `SpawnCommand`, but integrating the
result back into a pane resize action is not straightforward.

### Approach 3: Request Feature or Check for Updates

Since setting pane width directly in columns isn't supported natively, you can:

- Check the [WezTerm GitHub repository](https://github.com/wez/wezterm) for open
  issues or feature requests related to pane sizing by columns.
- Submit a feature request if one doesn't exist, as the WezTerm community and
  maintainers are active and might consider adding support for column-based
  sizing.

### Practical Recommendation

For now, the simplest and most effective method is **Approach 1**:

- Add a keybinding with `AdjustPaneSize` as shown above.
- Experiment with the cell count (e.g., `60` or another value) until the pane
  width is approximately 120 columns in your current setup.
- Note that if you change monitors, font sizes, or scaling, you may need to
  adjust the value.

Here's a refined keybinding to resize the current pane (adjust direction and
size as needed):

```lua
{
  key = "w",
  mods = "CMD|SHIFT",
  action = wezterm.action.AdjustPaneSize({ "Right", 60 }), -- Tweak 60 to match ~120 columns
},
```

If you have multiple splits and need to handle different pane positions (left or
right side), you can expand the logic in a callback to check the pane's
neighbors using `pane:get_pane()` or similar methods to determine which
direction to adjust.

### Additional Notes

- **Font Size Impact**: In your config, you have `font_size = 11`. If this
  changes, the cell-to-column ratio will change, so keep that in mind.
- **Display Scaling**: If you use WezTerm across different monitors or DPI
  settings, the approximation might vary.
- **Community Help**: If you're still struggling to get the right width,
  consider asking in the WezTerm Discussions or Discord for advice on
  calculating cells-to-columns for your specific setup.

If you'd like help with a more advanced script or further experimentation, let
me know!

# === USER ===

does wezterm have a "select mode" like tmux where you can select text and copy
it to the clipboard? if so, how do i enable it?

# === ASSISTANT ===

Yes, WezTerm does have a feature similar to tmux's "select mode" or "copy mode,"
which allows you to select and copy text from the terminal buffer using the
keyboard or mouse. In WezTerm, this is referred to as **Quick Select Mode** or
simply the selection functionality tied to the scrollback buffer. You can
navigate the scrollback, select text, and copy it to the clipboard.

WezTerm's selection and copy functionality is built-in and does not require
explicit "enabling" in the same way tmux's copy mode does. However, you can
customize the keybindings and behavior to make it more accessible or to mimic
tmux's workflow. Below, I'll explain how it works by default and how to
customize it to suit your needs.

### Default Selection and Copy Behavior in WezTerm

1. **Mouse Selection**:
   - By default, you can click and drag with the mouse to select text in
     WezTerm. The selected text is automatically copied to the clipboard (on
     most platforms like macOS, Windows, and Linux with a clipboard manager).
   - You can also hold `Shift` while clicking and dragging to override any mouse
     bindings and force a selection.

2. **Keyboard Navigation (Scrollback)**:
   - Use `Shift + UpArrow` or `Shift + DownArrow` to scroll through the terminal
     buffer line by line.
   - Use `Shift + PageUp` or `Shift + PageDown` to scroll by pages.
   - These actions allow you to view past output, but selection with the
     keyboard requires entering a specific mode or using custom keybindings (see
     below).

3. **Quick Select Mode**:
   - WezTerm provides a `QuickSelect` action that lets you jump to predefined
     patterns (like URLs or file paths) and select them for copying.
   - By default, this isn't bound to a key, but you can assign it (more on this
     below).

4. **Copy and Paste**:
   - Once text is selected (via mouse or keyboard), you can copy it to the
     clipboard with `CMD + C` (macOS) or `Ctrl + C` (Windows/Linux, depending on
     your setup).
   - Paste from the clipboard using `CMD + V` or `Ctrl + V`.

### Entering a tmux-like "Copy Mode"

WezTerm does not have an exact equivalent to tmux's copy mode (where you enter a
distinct mode to navigate and select text with keyboard commands), but you can
emulate it by leveraging the `ScrollToPrompt`, `QuickSelect`, or custom
keybindings to navigate the scrollback buffer and select text.

To start selecting text with the keyboard, you can use the `StartSelection`
action (if supported in your version) or rely on mouse selection combined with
keyboard scrolling. However, the most tmux-like experience comes from binding
keys to navigate the scrollback and copy text.

### Customizing Keybindings for a tmux-like Copy Mode

You can set up keybindings in your WezTerm configuration to mimic tmux's copy
mode behavior. Below is an example of how to create a simple "select mode"
workflow where you can scroll, select, and copy text using the keyboard.

Add the following to your `wezterm.lua` configuration file (typically located at
`~/.config/wezterm/wezterm.lua`):

```lua
local wezterm = require 'wezterm'

return {
  -- Other configurations...

  keys = {
    -- Other keybindings...

    -- Enter a "copy mode" by scrolling up with a custom keybinding
    { key = "[", mods = "CMD", action = wezterm.action.ScrollByPage(-1) }, -- Scroll up (like tmux prefix + [)
    { key = "]", mods = "CMD", action = wezterm.action.ScrollByPage(1) },  -- Scroll down

    -- Scroll line by line in the buffer
    { key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollByLine(-1) },
    { key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollByLine(1) },

    -- QuickSelect to jump to selectable items (like URLs or paths)
    { key = "q", mods = "CMD", action = wezterm.action.QuickSelect },

    -- Copy selected text to clipboard (if text is selected via mouse or QuickSelect)
    { key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },

    -- Paste from clipboard
    { key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
  },

  -- Enable QuickSelect for specific patterns (optional customization)
  quick_select_patterns = {
    -- Default patterns for URLs, file paths, etc.
    -- You can add custom regex patterns here if needed
  },

  -- Other configurations...
}
```

### Explanation of Keybindings

- **`CMD + [` and `CMD + ]`**: Mimics tmux's prefix + `[` to enter copy mode by
  scrolling up a page. Use `]` to scroll back down.
- **`SHIFT + UpArrow/DownArrow`**: Scrolls line by line through the buffer,
  allowing you to navigate to the text you want to select.
- **`CMD + q`**: Triggers `QuickSelect`, which highlights selectable items (like
  URLs or file paths) that you can copy.
- **`CMD + c` and `CMD + v`**: Standard copy and paste to/from the clipboard.

### Limitations Compared to tmux Copy Mode

- **Keyboard Selection**: Unlike tmux, WezTerm does not currently have a
  built-in mode where you can move a cursor with keys (like `h`, `j`, `k`, `l`)
  to select arbitrary text without a mouse. You can navigate the scrollback with
  the keyboard, but actual selection often requires the mouse or `QuickSelect`.
- **Workaround**: Use the mouse to select text after scrolling to the desired
  location with keyboard bindings, or rely on `QuickSelect` for specific
  patterns.

### Enabling Mouse Selection (if Disabled)

If mouse selection isn't working, ensure that mouse bindings aren't overriding
the default behavior. By default, WezTerm allows mouse selection, but you can
explicitly enable or customize it in your config:

```lua
return {
  -- Other configurations...

  -- Ensure mouse selection works (optional, as this is default)
  mouse_bindings = {
    {
      event = { Down = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.SelectTextAtMouseCursor("Cell"),
    },
    {
      event = { Drag = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.ExtendSelectionToMouseCursor("Cell"),
    },
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
    },
  },
}
```

This ensures clicking and dragging with the left mouse button selects text and
copies it to the clipboard upon release.

### Additional Tips

- **Check Clipboard Integration**: Ensure your system clipboard is accessible by
  WezTerm. On Linux, you might need a clipboard manager like `xclip` or
  `wl-clipboard` (for Wayland). On macOS and Windows, clipboard integration
  works out of the box.
- **Custom Patterns for QuickSelect**: If you often select specific types of
  text, customize `quick_select_patterns` in your config to match regex patterns
  for those items.
- **Future Updates**: WezTerm is actively developed, so check the
  [documentation](https://wezfurlong.org/wezterm/) or
  [GitHub repository](https://github.com/wez/wezterm) for new features related
  to keyboard-driven selection modes.

### Summary

WezTerm doesn't have an exact "select mode" like tmux, but it provides
scrollback navigation, mouse selection, and `QuickSelect` to achieve similar
functionality. By customizing keybindings, you can create a workflow that
approximates tmux's copy mode. If you need true keyboard-driven text selection
(without a mouse), you might need to submit a feature request to the WezTerm
project or use tmux within WezTerm for that specific functionality.

If you'd like more specific keybindings or help with a particular aspect of
selection, let me know!

# === USER ===


