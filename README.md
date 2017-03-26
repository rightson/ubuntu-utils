# Ubuntu Utils

This is a handy command line utility for lazy developers to configure Ubuntu 16.04 LTS without too many efforts - the only effort is to check below command line options.

This script can also be used by provisioning script for docker or vagrant : )

* Vim
  * equals to `sudo apt-get install -y vim` and vundle installation
* Git
  * equals to `sudo apt-get install -y git` and configure user.email and user.name with prompts
* GitCacheTimeout
  * setup cache timeout for git to prevent from entering account/password whenever push/pull from remote repository
* Zsh
  * equals to `sudo apt-get install -y zsh` and oh-my-zsh installation
* Tmux 
  * equals to `sudo apt-get install -y tmux` and tpm installation
* Ssh 
  * alias to `sudo apt-get install -y openssh-server`
* Nvm 
  * alias to `curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash`
* Yarn
  * setup repository and install Yarnpkg 
* Mongodb 
  * setup repository and install mongodb-org 
* Jdk
  * install JDK-8
* LinuxImage
  * install linux image of current running kernel version
* Samba 
  * install samba and add current user
* Nvidia
  * install Nvidia drivers


Some combo commands are supported too.

* Basics
  * equals to Vim + Git + Zsh + Tmux + Ssh + `sudo apt-get install -y build-essential tree`

* GuiBasics
  * equals to `sudo apt-get install vim-gnome terminator easystroke xdotool filezilla`

