#!/bin/bash

APT_GET="sudo apt-get"
INSTALL="$APT_GET install -y"
UPDATE="$APT_GET update"

Usage() {
    echo "Usage: $0 [Options]"
    echo ""
    echo "Combo Options:"
    echo "  Basics      - includes vim, git, zsh, tmux, openssh-server, tree, build-essentila"
    echo "  Gui_basics  - includes vim-gnome, terminator, easystroke, xdotool, filezilla"
    echo "  Update      - run apt-get update/upgrad/dist-upgrade and autoremove sequentially"
    echo "  Custom      - run your own custom combo installation"
    echo ""
    echo "Individual Options:"
    echo "  Vim | Git | GitCacheTimeout | Zsh | Tmux | Ssh | Docker | DockerCompose"
    echo "  Golang | Nvm | Yarn | Mongodb | Jdk | LinuxImage | Samba | Nvidia"
    echo "  LinuxImage | Samba | Nvidia"
    echo "  AptOverHttps"
    exit 0
}

Vim() {
    $INSTALL vim
    $INSTALL ctags
    $INSTALL cscope
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

Git() {
    $INSTALL git
    if [ -z "`git config --list | grep user.email`" ]; then
        echo -n "Please enter your email for git: "
        read email
        echo -n "Please enter your user name for git: "
        read username
        git config --global user.email "$email"
        git config --global user.name "$username"
    fi
}

GitCacheTimeout() {
    echo -n "Please enter your timeout of git password cache in seconds: "
    read timeout
    git config credential.helper "cache --timeout=$timeout"
}

Zsh() {
    $INSTALL zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

Tmux() {
    $INSTALL tmux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

Ssh() {
    $INSTALL openssh-server
}

Golang() {
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    $UPDATE
    $INSTALL golang-go
}

Nvm() {
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
    nvm install stable
}

Yarn() {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    $UPDATE && $INSTALL yarn
}

Mongodb() {
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
    $UPDATE
    $INSTALL mongodb-org
}

Jdk() {
    $INSTALL openjdk-8-jre
}

LinuxImage() {
    $APT_GET build-dep -y linux-image-$(uname -r)
}

Samba() {
    $INSTALL samba samba-common system-config-samba
    sudo smbpasswd -a `id -u`
}

Nvidia() {
    sudo add-apt-repository -y ppa:graphics-drivers/ppa
    $UPDATE
    $INSTALL nvidia-375
    sudo apt-get -f install
}

AptOverHttps() {
   $INSTALL apt-transport-https ca-certificates curl software-properties-common
}

Docker() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	$UPDATE
	$INSTALL docker-ce
}

DockerCompose() {
    local dst=/usr/local/bin/docker-compose
    if [ ! -f $dst ]; then
        sudo curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o $dst
        sudo chmod a+rx $dst
    else
        echo "docker-compose installed at $dst"
    fi
    $dst --version
}

Basics() {
    Vim
    Git
    Zsh
    Tmux
    Ssh
    $INSTALL tree
    $INSTALL build-essential
}

GuiBasics() {
    $INSTALL vim-gnome
    $INSTALL terminator
    $INSTALL easystroke
    $INSTALL xdotool
    $INSTALL filezilla
}

Custom() {
    $INSTALL ibus-chewing
}

Hostname() {
    local hostname=/etc/hostname
    local hosts=/etc/hosts
    local old_name=`cat $hostname`
    local new_name=$1
    sudo hostnamectl set-hostname $new_name
    sudo sed -i "s/$old_name/$new_name/g" $hostname
    echo "127.0.1.1 $new_name" | sudo tee --append $hosts
    sudo systemctl restart systemd-logind.service
}

Update() {
    $UPDATE
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo apt autoremove -y
}

if [ -z "$1" ]; then
    Usage
else
    $*
fi
