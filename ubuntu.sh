#!/bin/bash

set -e

DOTFILES_PATH="$HOME/.dotfiles"
SSH_KEYS_FILE="$HOME/.ssh/authorized_keys"
LMARS_PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGyktkwJsNHfBddvWSaIfF4lXkLYOx+e+ZlYkZ/GSy196hvgn2IhzH80Cj2bmNiT+2wS/STPYgASbDEHNFddGIKokQL3kj75K0xaX+hv2r52zmc839GFMB/INk6ch/7K+/LcsfSr1YpkXJPzqbekGAtkBRuezKLsQzbs7q5JK+jIAaAIo7e8NnLXSq1z5HQw2A7l8jSEeYv2PoQ9jAmJqz5cOlNmGnt6AfEetHlnH9RgHNY29cMTF4Xa2U/MHuJnYoXJCUUheVa8wirJUuxvrXCVMPdQDhr99FFTQdvXKZhuqATgeuEXSlSBim7rVYHV3lATf41e8KXy6txB98Lk7Z lewis@lmars.net"

function say() {
  local time=$(date +%H:%M:%S)
  echo -e "\033[0;32m$time - $@\033[0m"
}

function symlink() {
  local name=$1
  local source="$DOTFILES_PATH/home/$name"
  local dest="$HOME/$name"
  local overwrite=""

  # If dest exists
  if [ -e $dest ]; then
    # If dest is not a symlink or it is a symlink but not to source
    if [ ! -L $dest ] || [ -L $dest ] && [ "$(readlink $dest)" != $source ]; then
      echo -ne "\033[0;35m$name exists - overwrite? [y/n]: \033[0m"
      read overwrite

      if [ $overwrite == "y" ]; then
        rm $dest
        echo -e "\033[0;33mSymlinking $name\033[0m"
        ln -s $source $dest
      fi
    else
      echo -e "\033[0;33mIdentical $name\033[0m"
    fi
  else
    echo -e "\033[0;33mSymlinking $name\033[0m"
    ln -s $source $dest
  fi
}

say "This script uses sudo so may prompt for your password"

say "Updating apt sources"
sudo apt-get -y --quiet=2 update

say "Checking if Git is installed"
if ! which git >/dev/null; then
  say "Git is missing, installing..."
  sudo apt-get -y install git >/dev/null
fi

say "Checking if github.com ssh keys are installed..."
if [ ! -f /etc/ssh/ssh_known_hosts ] || [ -z "$(ssh-keygen -F github.com -f /etc/ssh/ssh_known_hosts 2>&1)" ]; then
  say "Installing github.com ssh keys"
  ssh-keyscan -H github.com 2>/dev/null | sudo tee -a /etc/ssh/ssh_known_hosts >/dev/null
fi

say "Checking you can sudo with no password"
if ! sudo -l | grep -q NOPASSWD; then
  say "Allowing sudo with no password"
  echo "$USER ALL = NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ssh_no_passwd >/dev/null
  sudo chmod 440 /etc/sudoers.d/ssh_no_passwd
fi

say "Checking for sudo agent forwarding"
if ! sudo -l | grep -q "env_keep+=SSH_AUTH_SOCK"; then
  say "Adding support for sudo agent forwarding"
  echo "Defaults env_keep+=SSH_AUTH_SOCK" | sudo tee /etc/sudoers.d/ssh_auth_sock >/dev/null
  sudo chmod 440 /etc/sudoers.d/ssh_auth_sock
fi

say "Checking lmars is in authorized_keys"

if ! grep -q "${LMARS_PUBKEY}" $SSH_KEYS_FILE; then
  say "Adding lmars key to authorized_keys"
  mkdir -p $(dirname $SSH_KEYS_FILE)
  echo "${LMARS_PUBKEY}" >> $SSH_KEYS_FILE
fi

say "Checking for dotfiles repo"
if [ ! -d "$DOTFILES_PATH/.git" ]; then
  say "Cloning dotfiles"
  git clone -q git@github.com:lmars/dotfiles.git $DOTFILES_PATH
fi

cd $DOTFILES_PATH

say "Updating dotfiles"
git pull -q origin master
git submodule -q init
git submodule -q sync
git submodule update

say "Symlinking dotfiles"
for dotfile in $(ls -A "$DOTFILES_PATH/home"); do
  symlink $dotfile
done
