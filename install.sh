#!/bin/bash

bold=$(tput bold)
norm=$(tput sgr0)

PACKAGES=(
    git
    vim
    vim-nox
    curl
    tmux
    zsh
)

function oh-my-zsh(){
    echo "Clone the repository"
    git clone https://github.com/robbyrussell/oh-my-zsh.git $(pwd)/oh-my-zsh
    echo "Clone zsh theme"
    curl -o $(pwd)/oh-my-zsh/custom/themes/zero.zsh-theme \
        https://gitlab.com/snippets/1778883/raw
    echo "Change your default shell"
    chsh -s /bin/zsh
    echo "Done!"
}

function vimeditor(){
    echo "Install vim-plug"
    curl -fLo ~/.dotfiles/vim/autoload/plug.vim --create-dirs \
    	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Linking vim/"
    ln -s $(pwd)/vim ~/.vim
}	

function main(){
    echo "${bold}==> Install essential packages${norm}"
    echo "Updating repositories ..."
    sudo apt update -qq
    sudo apt install -y ${PACKAGES[*]}
    echo "${bold}==> Create configuration files${norm}"
    for file in data/*
    do
        echo "Linking $file"
        if [ ! -f ~/.$(basename $file) ]; then
    	    ln -s $(pwd)/$file ~/.$(basename $file)
    	else
    	    mv ~/.$(basename $file) ~/.$(basename $file).bak
    	    ln -s $(pwd)/$file ~/.$(basename $file)
    	fi
    done
    echo "${bold}==> Install oh-my-zsh${norm}"
    oh-my-zsh
    echo "${bold}==> Install Vim editor${norm}"
    vimeditor
}

main

