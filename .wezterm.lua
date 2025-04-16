local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.color_scheme = 'zenbones_dark'
--config.default_prog = { 'ubuntu' }

config.colors = {
  foreground      = '#bfbdb6',
  background      = '#020202',
  cursor_bg       = '#ff8f40',
  cursor_fg       = '#2d3640',
  cursor_border   = '#ff8f40',
  selection_fg    = '#bfbdb6',
  selection_bg    = '#2d3640',
  scrollbar_thumb = '#0D0D0D',
  split           = '#2d3640',
  ansi            = {
    '#0D0D0D',
    '#DD3E25',
    '#aad94c',
    '#e6b450',
    '#59c2ff',
    '#d2a6ff',
    '#73b8ff',
    '#dedede',
  },
  brights         = {
    '#5c6773',
    '#DD3E25',
    '#aad94c',
    '#CFCA0D',
    '#59c2ff',
    '#d2a6ff',
    '#73b8ff',
    '#bfbdb6',
  },
  tab_bar         = {
    background = '#020202',
    active_tab = {
      bg_color = '#ff8f40',
      fg_color = '#020202',
    },
  },

}
config.font = wezterm.font {
  family = '0xProto Nerd Font'
}
config.harfbuzz_features = { 'ss01' }
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
wezterm.on("update-right-status", function(window, _)
  local background = "#020202"
  local foreground = "#bfbdb6"

  if window:leader_is_active() then
    background = "#ff8f40"
    foreground = "#020202"
  end
  window:set_left_status(wezterm.format {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = " " .. utf8.char(0xf140c) .. " " },
  })
end)
config.window_close_confirmation = 'NeverPrompt'
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = '\\',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'r',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection "Left",
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection "Down",
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection "Up",
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection "Right",
  },
  {
    key = 'LeftArrow',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { "Left", 5 },
  },
  {
    key = 'RightArrow',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { "Right", 5 },
  },
  {
    key = 'UpArrow',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { "Up", 5 },
  },
  {
    key = 'DownArrow',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { "Down", 5 },
  },
}
for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = wezterm.action.ActivateTab(i)
  })
end
return config
