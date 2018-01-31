#!/bin/bash

APT_GET="sudo apt-get"
INSTALL="$APT_GET install -y"
UPDATE="$APT_GET update"
DIST_VERSION=`lsb_release -a 2> /dev/null | grep Codename | cut -f 2`

function Usage() {
    echo -e "Usages: $0 CMD\nCMD:"
    grep "^function" $0 | sed 's/function/  /g' | sed 's/[{()]//g'
}

function Update() {
    $UPDATE
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo apt autoremove -y
}

function Vim() {
    $INSTALL vim
    $INSTALL ctags
    $INSTALL cscope
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

function Git() {
    if [ -z "`apt-cache policy | grep git-core`" ]; then
        sudo add-apt-repository -y ppa:git-core/ppa
    fi
    $UPDATE
    $INSTALL git
    if [ -z "`git config --list | grep user.email`" ]; then
        echo -n "Please enter your email for git: "
        read email
        echo -n "Please enter your user name for git: "
        read username
        git config --global user.email "$email"
        git config --global user.name "$username"
        git config --global push.default matching
    fi
}

function Zsh() {
    $INSTALL curl
    $INSTALL zsh
    chsh -s `which zsh`
    local ohmyzsh=$HOME/.oh-my-zsh 
    if [ -d $ohmyzsh ]; then
        rm -fr $ohmyzsh
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function Tmux() {
    $INSTALL tmux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function Ssh() {
    $INSTALL openssh-server
}

function Python() {
    $INSTALL python3-virtualenv
    $INSTALL python3-venv
    $INSTALL python3-pip
    sudo -H pip3 install --upgrade pip
    $INSTALL python3-dev
    $INSTALL ipython3
    $INSTALL ipython3-notebook
    sudo -H pip3 install jupyter
}

function Golang() {
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    $UPDATE
    $INSTALL golang-go
}

function Nvm() {
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
    source $PROFILE
    nvm install stable
}

function Yarn() {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    local apt_list_yarn=/etc/apt/sources.list.d/yarn.list
    if [ ! -f $apt_list_yarn ]; then
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee $apt_list_yarn
    fi
    $UPDATE && $INSTALL yarn
}

function ProtocolBuffers() {
    local version=$1
    if [ -z $version ]; then
        version=3.0.0
    fi
    local workspace=`mktemp -d`
    cd $workspace
    wget https://github.com/google/protobuf/releases/download/v$version/protoc-$version-linux-x86_64.zip && \
    unzip protoc-$version-linux-x86_64.zip && \
    sudo cp bin/protoc /usr/local/bin/protoc && \
    sudo rsync -av include/ /usr/local/include && \
    rm protoc-$version-linux-x86_64.zip
    cd -
    rm -fr $workspace
}

function Jdk() {
    $INSTALL openjdk-8-jre
}

function LinuxImage() {
    $APT_GET build-dep -y linux-image-$(uname -r)
}

function Docker() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	$UPDATE
	$INSTALL docker-ce
}

function DockerCompose() {
    local dst=/usr/local/bin/docker-compose
    if [ ! -f $dst ]; then
        sudo curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o $dst
        sudo chmod a+rx $dst
    else
        echo "docker-compose installed at $dst"
    fi
    $dst --version
}

function PostgreSQL() {
    local apt_list_pgdg=/etc/apt/sources.list.d/pgdg.list
    if [ ! -f $apt_list_pgdg ]; then
        sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ ${DIST_VERSION}-pgdg main" | sudo tee $apt_list_pgdg
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    fi
    $UPDATE
    $INSTALL postgresql-9.6 
}

function Redis() {
    $INSTALL redis-server
}


function Mongodb() {
    local apt_list_mongo=/etc/apt/sources.list.d/mongodb-org-3.4.list
    if [ ! -f $apt_list_mongo ]; then
        echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee $apt_list_mongo
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
    fi
    $UPDATE
    $INSTALL mongodb-org
}

function Neo4j() {
    let apt_list_neo4j=/etc/apt/sources.list.d/neo4j.list
    if [ ! -f $apt_list_neo4j ]; then
        wget -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -
        echo 'deb https://debian.neo4j.org/repo stable/' | sudo tee /etc/apt/sources.list.d/neo4j.list
    fi
    $UPDATE
    $INSTALL neo4j
}

function Mosquitto() {
    sudo apt-add-repository -y ppa:mosquitto-dev/mosquitto-ppa
    $UPDATE
    $INSTALL mosquitto
}

function Samba() {
    $INSTALL samba samba-common system-config-samba
    sudo smbpasswd -a `id -u`
}


function NvidiaGraphicDriver() {
    sudo add-apt-repository -y ppa:graphics-drivers/ppa
    $UPDATE
    local latestVersion=`apt-cache search nvidia-\d+ | tail -n 1 | cut -d ' ' -f 1`
    $INSTALL $latestVersion
    sudo apt-get -f install
}

function Chewing() {
    $INSTALL ibus-chewing
}

function LibreOffice() {
    if [ -z "`apt-cache policy | grep libreoffice`" ]; then
        sudo add-apt-repository -y ppa:libreoffice/ppa
    fi
    $UPDATE
    sudo apt-get dist-upgrade -y
}

function Hostname() {
    local hostname=/etc/hostname
    local hosts=/etc/hosts
    local old_name=`cat $hostname`
    local new_name=$1
    echo "set hostname to $new_name from $old_name"
    sudo sed -i "s/$old_name/$new_name/g" $hostname
    sudo sed -i "s/$old_name/$new_name/g" $hosts
    exit 0
}

function AptOverHttps() {
   $INSTALL apt-transport-https ca-certificates curl software-properties-common
}

function GitCacheTimeout() {
    echo -n "Please enter your timeout of git password cache in seconds: "
    read timeout
    git config credential.helper "cache --timeout=$timeout"
}

function SaveAllVBox() {
    local option=${1-savestate}
    cmd="VBoxManage list runningvms | cut -d ' ' -f1 | xargs -I{} VBoxManage controlvm {} $option"
    echo $cmd
    $cmd
}

function Basics() {
    Vim
    Git
    Zsh
    Tmux
    Ssh
    $INSTALL tree
    $INSTALL build-essential
}

function GuiBasics() {
    $INSTALL vim-gnome
    $INSTALL terminator
    $INSTALL easystroke
    $INSTALL xdotool
    $INSTALL filezilla
}

Custom() {
    echo "Define your custom action"
}


# Entry

if [ -z "$1" ]; then
    Usage
else
    $*
fi
