#!/bin/bash

APT_GET="sudo apt-get"
INSTALL="$APT_GET install -y"

vim() {
    $INSTALL vim
    $INSTALL ctags 
    $INSTALL cscope
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

git() {
    $INSTALL git
    echo "Please enter your email for git: "
    read email
    echo "Please enter your user name for git: "
    read username
    git config --global user.email "$email"
    git config --global user.name "$username"
}

zsh() {
    $INSTALL zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

tmux() {
    $INSTALL tmux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

ssh() {
    $INSTALL openssh-server
}

nvm() {
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
    nvm install stable
}

yarn() {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update && sudo apt-get install -y yarn
}

mongodb() {
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
    sudo apt-get update 
    sudo apt-get install -y mongodb-org
}

jdk() {
    $INSTALL openjdk-8-jre
}

linux_image() {
    $APT_GET build-dep -y linux-image-$(uname -r)
}

samba() {
    $INSTALL samba samba-common system-config-samba
    sudo smbpasswd -a `id -u`
}

nvidia() {
    sudo add-apt-repository -y ppa:graphics-drivers/ppa
    sudo apt-get update
    $INSTALL nvidia-375
    sudo apt-get -f install
}

basics() {
    vim
    git
    zsh
    tmux
    ssh
    $INSTALL tree
    $INSTALL build-essential
}

gui_basics() {
    $INSTALL vim-gnome 
    $INSTALL terminator
    $INSTALL easystroke
    $INSTALL xdotool
    $INSTALL filezilla
}

custom() {
    $INSTALL ibus-chewing
}

update() {
    sudo apt-get update 
    sudo apt-get -y upgrade 
    sudo apt-get -y dist-upgrade 
    sudo apt autoremove -y
}

if [ -z $1 ]; then 
    echo "Usage: $0 [Options]"
    echo ""
    echo "Combo Options:"
    echo "  basics      - includes vim, git, zsh, tmux, openssh-server, tree, build-essentila" 
    echo "  gui_basics  - includes vim-gnome, terminator, easystroke, xdotool, filezilla"
    echo "  update      - run apt-get update/upgrad/dist-upgrade and autoremove sequentially"
    echo "  custom      - run your own custom combo installation"
    echo ""
    echo "Individual Options:"
    echo "  vim | git | zsh | tmux | ssh | nvm | yarn | mongodb | jdk | linux_image | samba | nvidia"
else
    $*
fi
