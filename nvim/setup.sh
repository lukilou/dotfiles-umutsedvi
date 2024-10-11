#!/bin/bash
#******************************************************************************
#
# * File: nvim/setup.sh
#
# * Author:  Umut Sevdi
# * Created: 08/18/24
# * Description: Neovim setup script.
#*****************************************************************************


get_nvim() {
    cd /tmp
    wget "https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz"
    tar -xvf nvim-linux64.tar.gz -C ~/.local/bin/
}

get_packer() {
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

# clangd bashls cssls diagnosticsls dockerls grammarly html jsonls tsserver
get_pnpm() {
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    pnpm add bash-language-server diagnostic-languageserver \
    grammarly-languageserver typescript-language-server \
    vscode-langservers-extracted -g
    go install github.com/go-delve/delve/cmd/dlv@latest
}

run() {
    if [ -f "$HOME/.local/bin/nvim-linux64/bin/nvim" ]; then
        "$HOME/.local/bin/nvim-linux64/bin/nvim" --headless -c 'PackerSync' -c 'PackerUpdate' -c 'qall'
    fi
}

usage(){
   echo "Usage: $0 --{neovim|packer|pnpm|prepare}"
}

help() {
   echo "Neovim setup script"
   echo "Runs selected steps to install neovim with plugins."
   echo
   usage
   echo
   echo "Options:"
   echo "-a/--all       Performs all of the given actions in a sequence."
   echo "-h/--help      Prints this menu."
   echo
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while [ -n "$1" ]; do
    case $1 in
        --neovim)
            get_nvim
            ;;
        --packer)
            get_packer
            ;;
        --pnpm)
            get_pnpm && source "$HOME/.bashrc"
            ;;
        --prepare)
            run
            ;;
        --all|-a)
            get_nvim && \
            get_pnpm && \
            source "$HOME/.bashrc" \
            get_packer && \
            run
            ;;
        *)
            help && exit 1
            ;;
    esac
    shift
done
