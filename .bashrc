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

# ┌──────────────────────┐
# │   Path  Management   │
# └──────────────────────┘

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export GOPATH=$HOME/.config/go
export GOROOT=$HOME/.config/go
export JAVA_HOME="$(ls /lib/jvm | grep java-11-openjdk.)"
export DOT_PATH=$HOME/.dotfiles/bin
export PATH="/sbin:$JAVA_HOME:$GOPATH/bin:$GOROOT/bin:$DOT_PATH::$PATH"

export EDITOR=~/.local/share/nvim-linux64/bin/nvim
export TODO_DB_PATH=$HOME/.config/umutsevdi/env/todo.json

alias wget=wget --hsts-file="$HOME/.config/.wget-hsts"
export QT_QPA_PLATFORMTHEME=gnome
export LESSHISTFILE=$HOME/.config/.lesshst
export XDG_DATA_HOME=$HOME/.local/share/
export XDG_CONFIG_HOME=$HOME/.config/
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

# User specific aliases and functions
if [ -d $HOME/.bashrc.d ]; then
    for rc in $HOME/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

unset rc
[[ $- != *i* ]] && return

[[ $- == *i* ]] && source "/home/umutsevdi/.fzf/shell/completion.bash" 2> /dev/null

# Generate the neovim directory for the color changes
mkdir /tmp/nvim  2>/dev/null

# ┌──────────────────────┐
# │       Aliases        │
# └──────────────────────┘
case tty in
    *"tty"*)
        
        ;;
    *)
        [ -f /etc/bash_completion ] && . /etc/bash_completion
        ;;
esac

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

alias nvim='nvim --listen /tmp/nvim/$((`ls /tmp/nvim | tail -n 1`+1))'
alias tmux="tmux -f $HOME/.dotfiles/config/tmux.conf"
alias vim='vim -u $HOME/.dotfiles/config/vimrc'

# turns each folder under the src directory into a command that performs fuzzy-find
# inside the directories
__fzf_alias() {
    cd $(find $1 -type d -not -path '*/[@.]*' | fzf -i -x)
}

for i in `ls $HOME/src/`; do
    alias $i="__fzf_alias $HOME/src/$i; tmux"
done

# Typo aliases
alias sl=ls
alias v=vim
alias n=nvim
alias nivm=nvim
alias cs=colorscheme

# ┌──────────────────────┐
# │       Setup PS1      │
# └──────────────────────┘
ps_t="\[\e[34;1m\]\t"
ps_dir="\[\e[33;3m\]\W"
ps_git="\[\e[;0m\]\[\e[33;3m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')"
ps_arrow=" → \[\e[39;0m\]"
export PS1="$ps_t $ps_dir$ps_git $ps_arrow"

# ┌──────────────────────┐
# │      Initialize      │
# └──────────────────────┘
echo -e "\e[33;1m`whoami`@`hostname` - \e[36m`date +%a' '%d' '%b' '%Y`"
echo -e "\e[33;1m──────────────────────────────────\e[39;0m"
$HOME/.dotfiles/bin/pots


