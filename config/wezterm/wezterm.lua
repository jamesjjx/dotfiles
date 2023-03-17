local wezterm = require 'wezterm'
local keymap = function (from_key, from_mods, to_key, to_mods)
  return {
    key=from_key,
    mods=from_mods,
    action = wezterm.action.SendKey({ key = to_key, mods = to_mods })
  }
end

local M = {
  font = wezterm.font_with_fallback({
    'Iosevka Term SS14',
    { family = 'Symbols Nerd Font Mono', scale = 0.7 },
  }),
  font_size = 13,
  color_scheme = "nord",
  keys = {
    -- fish keymaps
    keymap('.', 'CMD', '.', 'OPT'),
    keymap('f', 'CMD', 'f', 'OPT'),
    -- tmux
    keymap(';', 'CMD', 'b', 'OPT'),
    -- select panes
    { key = '8', mods = 'CTRL', action = wezterm.action.PaneSelect },
  },

  default_cursor_style = 'SteadyBar',
  hyperlink_rules = {
    {
      regex = [[\b(cl|b)/(\d+)]],
      format = 'http://$0',
    },
  },

  -- Give fancy tab bar a try once it's fully implemented. https://github.com/wez/wezterm/issues/1180
  -- For now, I'll just customize format-tab-title event.
  use_fancy_tab_bar = false,
  tab_max_width = 32,
  colors = {
    tab_bar = {
      inactive_tab_hover = {
        italic = false,
        -- bg/fg colors don't matter, because they will be overwritten in format-tab-title anyway. But they are required.
        bg_color = 'Black',
        fg_color = 'White',
      }
    }
  },
}

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local nord = {
      -- nord[1..4]: dark
      '#2E3440', '#3B4252', '#434C5E', '#4C566A',
      -- nord[5..7]: bright
      '#D8DEE9', '#E5E9F0', '#ECEFF4',
      -- nord[8..11]: green to blue
      '#8FBCBB', '#88C0D0', '#81A1C1', '#5E81AC',
      -- nord[12..16]: red, orange, yellow, green, purple
      '#BF616A', '#D08770', '#EBCB8B', '#A3BE8C', '#B48EAD',
    }
    local title = tab.active_pane.title
    local res = {}
    if tab.is_active then
      res = {
        {Attribute={Intensity="Bold"}},
        { Background = { Color = nord[1] } },
        { Foreground = { Color = nord[6] } },
        { Text = ' ' .. title .. ' ' },
      }
    elseif hover then
      res = {
        {Attribute={Intensity="Normal"}},
        {Attribute={Italic=true}},
        { Background = { Color = nord[2] } },
        { Foreground = { Color = nord[5] } },
        { Text = ' ' .. title .. ' ' },
      }
    else
      res = {
        {Attribute={Intensity="Half"}},
        { Background = { Color = nord[2] } },
        { Foreground = { Color = nord[5] } },
        { Text = ' ' .. title .. ' ' },
      }
    end
    if tab.tab_index < #tabs - 1 then
      table.insert(res, 'ResetAttributes')
      table.insert(res, { Background = { Color = nord[2] } })
      table.insert(res, { Foreground = { Color = nord[11] } })
      table.insert(res, { Text = '|' })
    end
    return res
  end
)

return M
