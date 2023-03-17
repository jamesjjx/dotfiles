# search in recomended installation locations (macOS, macOS M1, Linux (global/default), Linux alternative method)
set -l possible_brew_paths /usr/local/bin/brew /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew ~/.linuxbrew/bin/brew 
for possible_brew_path in $possible_brew_paths
  if test -f $possible_brew_path
    eval ($possible_brew_path shellenv)
  end
end
