function fish_prompt
  set -l last_status $status

  set_color normal
  echo -n (prompt_pwd)
  echo -n ' $ '

  # status
  echo -n -s '  '
  if test $CMD_DURATION
    # Show duration of the last command in seconds
    set -l duration (math $CMD_DURATION / 1000)s
    set -l time (date +%k:%M:%S)
    if test $last_status -eq 0
      echo -n (set_color green) $duration "($last_status)"
    else
      echo -n (set_color red) $duration "($last_status)"
    end
      echo -n (set_color $fish_color_comment) " $time"
  end

  echo
  set_color $fish_color_comment; echo -n '><> '; set_color normal
end
