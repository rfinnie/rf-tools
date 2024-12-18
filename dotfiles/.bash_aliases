#!/bin/bash

shopt -s histappend
export HISTFILESIZE=10000000
export HISTFILE=~/.bash_history_append
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %H:%M:%S      "
export PROMPT_COMMAND='history -a'

export MAILUSER=ryan
export MAILHOST=finnie.org
export MAILNAME="Ryan Finnie"
export TZ="America/Los_Angeles"

export DEBEMAIL="${MAILUSER}@${MAILHOST}"
export DEBFULLNAME="${MAILNAME}"

alias tad="tmux attach -d"
__title_wrapper() {
  (
    prog="$1"; shift
    if [ -n "$COMP_LINE" ] || [ ! -t 1 ]; then
      exec "$prog" "$@"
    fi
    case "$TERM" in
    xterm*|rxvt*)
      echo -ne "\033]0;$* ($prog)\007"
      ;;
    esac
    exec "$prog" "$@"
  )
}
alias ssh='__title_wrapper ssh'
alias telnet='__title_wrapper telnet'
alias shaboom='sudo apt-get update && sudo apt-get -u dist-upgrade && sudo apt-get --purge autoremove && sudo apt-get clean && [ -x /usr/bin/toilet ] && (toilet -f future --metal "Kaboom-shakalaka!" || echo "Kaboom-shakalaka!")'
alias how2main='echo "( git checkout master && git branch -m master main && git fetch && git branch --unset-upstream && git branch -u origin/main && git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main )"'
alias k8s-just-give-me-a-shell='kubectl run finnix-$(uuidgen | cut -b -4 | tr A-Z a-z) --image=finnix/finnix --restart=Never -it --rm'
b64out() {
    c=70
    cmd=base64
    if command -v gbase64 >/dev/null 2>/dev/null; then
        cmd=gbase64
    fi
    if [ -n "${COLUMNS}" ]; then
        c=$((COLUMNS - 10))
    fi
    gzip -9 -c | "${cmd}" -w${c}
}
alias b64diff='git diff | b64out'
alias b64patch='base64 -d | gunzip -c | patch -p1'

if [ "$COLORTERM" = "gnome-terminal" ]; then
    case "$TERM" in
    xterm*)
        TERM="xterm-256color"
        ;;
    screen*)
        TERM="screen-256color"
        ;;
    esac
fi

__git_ps1() { return; }
if [ -e /etc/bash_completion.d/git-prompt ]; then
  # shellcheck disable=SC1091
  . /etc/bash_completion.d/git-prompt
elif [ -e /usr/local/share/git-core/contrib/completion/git-prompt.sh ]; then
  # shellcheck disable=SC1091
  . /usr/local/share/git-core/contrib/completion/git-prompt.sh
fi
__ps1_local() { return; }
__gronk() { zoot=$?; if [[ $zoot != 0 ]]; then echo "$zoot "; fi }
__hostcolor="$(($(echo -n "$(hostname)" | cksum | cut -f1 -d' ') % $((231-124)) + 124))"
# shellcheck disable=SC2154
_d="${debian_chroot}"
PS1="${_d:+(${_d})}\[\e[38;5;202m\]\$(__gronk)\$(__ps1_local)\[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;${__hostcolor}m\]\h\[\e[00m\]:\[\e[38;5;172m\]\w\[\e[00m\]\$(__git_ps1 {%s})\$ "

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${_d:+(${_d})}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

unset _d

if [ -z "${GPG_TTY}" ] && tty 2>/dev/null >/dev/null; then
    GPG_TTY="$(tty)"; export GPG_TTY
fi

if [ -e ~/.local/lib/python3/startup.py ]; then
  export PYTHONSTARTUP=~/.local/lib/python3/startup.py
fi

__tmux_status_host() {
  if [ -e /sys/devices/virtual/thermal/thermal_zone0/temp ]; then
    echo $(($(cat /sys/devices/virtual/thermal/thermal_zone0/temp)/1000))°
  elif [ -e /sys/devices/platform/it87.656/hwmon/hwmon1/temp1_input ]; then
    echo $(($(cat /sys/devices/platform/it87.656/hwmon/hwmon1/temp1_input)/1000))°
  else
    echo '☃'
  fi
}

if [ -n "$SSH_CLIENT" ] && [ "$SHLVL" = "1" ] && tty >/dev/null 2>/dev/null && [ "$TERM" = "xterm-256color" ]; then
  perl -e '$e = chr(27); if($ENV{SSH_CLIENT} =~ /^([a-f0-9:]+) /) { $a = $1; $m = "IPv6"; $c = 34; } elsif($ENV{SSH_CLIENT} =~ /^([0-9\.]+) /) { $a = $1; $m = "IPv4"; $c = 33; }; print "${e}[1;${c}m${m}${e}[0;39m client: ${e}[1;37m${a}${e}[0;39m\n"' 1>&2 2>/dev/null
fi

if [[ "${PATH}" != *"/usr/sbin"* ]]; then
    _do=()
    IFS=':' read -r -a _di <<< "${PATH}"
    for i in "${_di[@]}"; do
        [ "${i}" = "/usr/local/bin" ] && _do[${#_do[@]}]="/usr/local/sbin"
        [ "${i}" = "/usr/bin" ] && _do[${#_do[@]}]="/usr/sbin"
        [ "${i}" = "/bin" ] && _do[${#_do[@]}]="/sbin"
        _do[${#_do[@]}]="${i}"
    done
    PATH="$(IFS=:; echo "${_do[*]}")"
    unset _di
    unset _do
fi

if [ -e ~/.bash_aliases.local ]; then
  # shellcheck disable=SC1090
  . ~/.bash_aliases.local
fi
