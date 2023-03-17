# color scheme
#base16-zenburn
source ~/.config/fish/nord.fish
source ~/.config/fish/brew.fish

# To reload fish configs for all existing sessions:
# set -U _reload_config 1
function _on_reload_config_change --on-variable _reload_config
  if test $_reload_config -eq 0
    return
  end
  source ~/.config/fish/config.fish
  set -U _reload_config 0
  set_color yellow
  echo "fish.config has been reloaded."
  set_color normal
end

function send_bend_in_inactive_tmux_window --on-event fish_postexec
  test -n "$TMUX"
  and test (tmux display -p -t $TMUX_PANE '#{window_active}') -eq 0
  and echo -n -e "\a"
end
