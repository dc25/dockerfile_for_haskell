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

BUILDER_COPY_FILES="myVimrc myBashrc .vimrc .vim .bashrc .ghc .haste"

cd /home/builder/
sudo su $USER_NAME -c "find $BUILDER_COPY_FILES -depth -print0 | cpio -pdum0 \$HOME > /dev/null 2>&1"

## Link to some large configuration directories in /home/builder
## Is the .ghcjs directory even necessary when using sandboxes?
for s in .ghcjs ; do
    sudo su $USER_NAME -c "ln -s /home/builder/$s \$HOME"
done

sudo su $USER_NAME -c "cabal update"

sudo su $USER_NAME -c /home/builder/workarea/personalize.sh

echo "sshd started"
sudo /usr/bin/svscan /services/
## sudo su $USER_NAME bash -c tmux
