shopt -s histappend
export HISTFILE=~/.bash_history
export HISTCONTROL=ignoreboth
export HISTFILESIZE=1000000
export HISTSIZE=10000
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
    if [ -n "$COMP_LINE" ]; then
      exec "$prog" "$@"
    fi
    case "$TERM" in
    xterm*|rxvt*)
      echo -ne "\033]0;""$@"" ($prog)\007"
      ;;
    esac
    exec "$prog" "$@"
  )
}
alias ssh='__title_wrapper ssh'
alias telnet='__title_wrapper telnet'
alias shaboom='sudo apt-get update && sudo apt-get -u dist-upgrade && sudo apt-get --purge autoremove && sudo apt-get clean && [ -x /usr/bin/toilet ] && (toilet -f future --metal "Kaboom-shakalaka!" || echo "Kaboom-shakalaka!")'
alias git-last-commit-now='git commit --amend --date=now --no-edit'

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

if [ -e /etc/bash_completion.d/git-prompt ]; then
  . /etc/bash_completion.d/git-prompt
elif [ -e /usr/local/share/git-core/contrib/completion/git-prompt.sh ]; then
  . /usr/local/share/git-core/contrib/completion/git-prompt.sh
else
  __git_ps1() { return; }
fi
if [ -e "$HOME/bin/rf-local-ps1" ]; then
  . "$HOME/bin/rf-local-ps1"
else
  __rf_local_ps1() { return; }
fi
__gronk() { zoot=$?; if [[ $zoot != 0 ]]; then echo "$zoot "; fi }
__hostcolor="$(($(echo -n "$(hostname)" | cksum | cut -f1 -d' ') % $((231-124)) + 124))"
PS1="${debian_chroot:+($debian_chroot)}\[\e[38;5;202m\]\$(__gronk)\$(__rf_local_ps1)\[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;${__hostcolor}m\]\h\[\e[00m\]:\[\e[38;5;172m\]\w\[\e[00m\]\$(__git_ps1 {%s})\$ "

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export GPG_TTY="$(tty 2>/dev/null >/dev/null && tty || true)"

if [ -e ~/.pythonstartup ]; then
  export PYTHONSTARTUP=~/.pythonstartup
fi

if [ -e ~/.bash_aliases.local ]; then
  . ~/.bash_aliases.local
fi
