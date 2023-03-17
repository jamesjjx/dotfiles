# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# start fish shell
if [[ $- = *i* && -z $WHICH_FISH ]] && WHICH_FISH=$(type -p fish); then
  # Safeguard to only activate fish for interactive shells and only if fish
  # shell is present and executable. Verify that this is a new session by
  # checking if $WHICH_FISH is set. If it is not set, we export WHICH_FISH
  # and start fish.
  #
  # If this is not a new session, the user probably typed 'bash' into their
  # console and wants bash, so we skip this.
  #
  # Note that we do not set $SHELL, and neither does fish, because doing so
  # tends to interfere with programs that expect $SHELL to point to a
  # POSIX-compatible shell, which fish is not.
  export WHICH_FISH
  exec "$WHICH_FISH" -i
fi

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\[\033[01;32m\]\$\[\033[00m\] '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
