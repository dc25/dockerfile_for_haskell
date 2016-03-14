#!/bin/bash

export USER_NAME=$1
export USER_ID=$2
export USER_KEY=$3

echo "configuring user: $USER_NAME ..."

sudo adduser --disabled-password --gecos '' --uid $USER_ID $USER_NAME > /dev/null 2>&1 
sudo adduser $USER_NAME sudo > /dev/null 2>&1 

sudo su $USER_NAME -c "mkdir \$HOME/.ssh"
sudo su $USER_NAME -c "echo $USER_KEY > \$HOME/.ssh/authorized_keys"
sudo su $USER_NAME -c "chmod 600 \$HOME/.ssh/authorized_keys"

WORKAREA=/home/builder/workarea/
cd $WORKAREA

sudo su $USER_NAME -c "cp tmux.conf ~/.tmux.conf"
sudo su $USER_NAME -c "cp vimrc ~/.vimrc"
sudo su $USER_NAME -c "cp myVimrc ~"
sudo su $USER_NAME -c "cp myBashrc ~"
sudo su $USER_NAME -c "echo '. ~/myBashrc' >> ~/.bashrc"

cd $HOME/.vim
sudo su $USER_NAME -c "find . -depth -print | cpio -pdvum ~/.vim" > /dev/null 2>&1

sudo su $USER_NAME -c "cabal update"

sudo su $USER_NAME -c "$WORKAREA/personalize.sh"

echo "sshd started"
sudo /usr/bin/svscan /services/
## sudo su $USER_NAME /bin/bash -c tmux
