#!/bin/bash

checkExit() {
if [ $1 != 0 ]
then
    exit 1
fi
}

addUser() {

echo -n "Please enter your new user's name:"
read username
sudo useradd $username

checkExit $?

echo -n "Please enter new password for new user:"
read -s new_user_password

sudo passwd $username << PASSWORD
$new_user_password
$new_user_password
PASSWORD

sudo usermod -aG sudo $username

checkExit $?
}


echo -n "Please enter your password:"
read -s password
echo

echo -n "Would you like to create a new user to install ss?[y/N]"
read -n 1 confirm
echo

if [ "$confirm" == "n" -o "$confirm" == "N" ]
then
    echo
else
    addUser
fi

echo $password | sudo -S apt-get update

# Install Requirements
sudo apt-get install -y python python-pip git make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev fonts-powerline

echo $password | sudo apt-get install -y zsh

#----- Split ---------

# Install Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.zshrc
echo 'export PATH="$HOME/.pyenv/bin:$HOME/.local/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
source ~/.zshrc

pyenv install 2.7.13

checkExit $?

pyenv global 2.7.13

pip install virtualenvwrapper

git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper

echo 'export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"' >> ~/.zshrc
echo "pyenv virtualenvwrapper" >> ~/.zshrc

source ~/.zshrc


