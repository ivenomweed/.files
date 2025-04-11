local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.color_scheme = 'zenbones_dark'
config.default_prog = { 'ubuntu' }

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
}
config.font = wezterm.font {
  family = '0xProto Nerd Font'
}
config.harfbuzz_features = { 'ss01' }
config.enable_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'
config.keys = {
  {
    key = 't',
    mods = 'CTRL',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
  {
    key = '/',
    mods = 'CTRL',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '?',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '.',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
}
return config
