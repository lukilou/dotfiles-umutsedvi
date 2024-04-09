# .bashrc
#******************************************************************************
#
# * File: .dotfiles/.bashrc
#
# * Author:  Umut Sevdi
# * Created: 03/31/22
# * Description: .bashrc configuration
#*****************************************************************************

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

unset color_prompt force_color_prompt

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

 # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
 # sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ┌──────────────────────┐
# │   Path  Management   │
# └──────────────────────┘

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export GOPATH=$HOME/.config/go
export JAVA_HOME="$(ls /lib/jvm | grep java-11-openjdk.)"
export DOT_PATH=$HOME/.dotfiles/bin
export FLUTTER_PATH=$HOME/.local/bin/flutter/bin
export PATH="/sbin:$JAVA_HOME:$GOPATH/bin:$GOROOT/bin:$DOT_PATH::$FLUTTER_PATH:$PATH"


# Generate the neovim directory for the color changes
mkdir /tmp/nvim  2>/dev/null

alias nvim="nvim -u ~/.dotfiles/nvim/init.lua --listen /tmp/nvim/$((`ls /tmp/nvim | tail -n 1`+1))"
export EDITOR=nvim
export TODO_DB_PATH=$HOME/.config/shared/todo.json

alias wget=wget --hsts-file="$HOME/.config/.wget-hsts"
export CHROME_EXECUTABLE=firefox
export QT_QPA_PLATFORMTHEME=gnome
export LESSHISTFILE=$HOME/.config/.lesshst
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export XAUTHORITY="$XDG_CONFIG_HOME"/.Xauthority
export ANDROID_HOME="$XDG_CONFIG_HOME/android"
export GRADLE_USER_HOME="$XDG_CONFIG_HOME/gradle"
export XCURSOR_PATH=/usr/share/icons:${XDG_DATA_HOME}/icons
export HISTFILE=$HOME/.config/history
export TERMINAL=/bin/alacritty
export QT_QPA_PLATFORMTHEME=gnome
export QUOTE_PATH=$HOME/Documents/quotes
export VPN_STATUS_PATH=$HOME/.config/umutsevdi/env/
export WINEPREFIX="$XDG_DATA_HOME"/wine
# sudo alternatives --config java

unset rc
[[ $- != *i* ]] && return
[[ $- == *i* ]] && source "/home/umutsevdi/.fzf/shell/completion.bash" 2> /dev/null

# ┌──────────────────────┐
# │       Aliases        │
# └──────────────────────┘

FZF_DEFAULT_COMMAND="find -L"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias la='ls -A'
alias ..='cd ..'
alias gs='git status'
alias mv='mv -i'
alias rm='rm -i'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias ff='x=$(fzf);cd $(dirname $x); nvim $(basename $x)'
alias open='xdg-open "$(fzf)"'

alias tmux="tmux -f $HOME/.dotfiles/config/tmux.conf"
alias vim='vim -u $HOME/.dotfiles/config/vimrc'

# turns each folder under the src directory into a command that performs fuzzy-find
# inside the directories
__fzf_alias() {
    cd $(find $1 -type d -not -path '*/[@.]*' | fzf -i -x)
}

# Index directories under ~/src
for i in `ls $HOME/src/`; do
    alias $i="__fzf_alias $HOME/src/$i; tmux"
done

# Typo aliases
alias sl=ls
alias v=vim
alias n=nvim
alias nivm=nvim
alias cs=colorscheme

if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
    # Wayland is enabled, export environment variables
    export GDK_BACKEND="wayland,x11"
    export WAYLAND_DISPLAY="wayland-0"
    export DISPLAY="wayland-0"
fi

# ┌──────────────────────┐
# │       Setup PS1      │
# └──────────────────────┘
ps_t="\[\e[34;1m\]\t"
ps_dir="\[\e[33;3m\]\W"
ps_git="\[\e[;0m\]\[\e[33;3m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')"
ps_arrow="$ \[\e[39;0m\]"
export PS1="$ps_t $ps_dir$ps_git $ps_arrow"
$HOME/.dotfiles/bin/pots
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
