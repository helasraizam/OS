#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '


# ENV Variables
# Use emacs as default editor
export EDITOR="emacs"

# Completes terminal text with history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

# Import aliases
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# xterm transparency (requires xcompmgr and transset-df)
# See https://wiki.archlinux.org/index.php/xcompmgr
[ -n "$XTERM_VERSION" ] && transset-df -a .5 >/dev/null
