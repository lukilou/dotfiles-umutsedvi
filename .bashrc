# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# ┌──────────────────────┐
# │   Path  Management   │
# └──────────────────────┘

export GOPATH=$HOME/.config/go
export GOROOT=/lib/go
export JAVA_HOME="$(ls /lib/jvm | grep java-11-openjdk.)"
export DOT_PATH=$HOME/.dotfiles/bin
export PATH="$JAVA_HOME:$GOPATH/bin:$GOROOT/bin:$DOT_PATH::$PATH"
export EDITOR=/usr/bin/nvim
export TODO_DB_PATH=$HOME/.config/todo.json
# ┌──────────────────────┐
# │ Directory Management │
# └──────────────────────┘

export LESSHISTFILE=$HOME/.config/.lesshst
alias wget=wget --hsts-file="$HOME/.config/.wget-hsts"
export XDG_DATA_HOME=$HOME/.local/share/
export XDG_CONFIG_HOME=$HOME/.config/
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache
export QT_QPA_PLATFORMTHEME=gnome
export HISTFILE=$HOME/.config/history
export TERMINAL=/bin/alacritty
export QT_QPA_PLATFORMTHEME=gnome
export QUOTE_PATH=$HOME/Documents/quotes
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

alias nvim='nvim --listen /tmp/nvim/$((`ls /tmp/nvim | tail -n 1`+1))'
alias tmux="tmux -f $HOME/.dotfiles/tmux/.tmux.conf"

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
