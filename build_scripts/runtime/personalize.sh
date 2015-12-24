#! /bin/bash

# This script sets up a user's environment when a docker container starts up.
# Edit to suit your own tastes.


BUILDER_COPY_FILES="myVimrc startup .ssh/authorized_keys .vimrc .vim .bashrc .ghc .haste"

cd /home/builder/
find $BUILDER_COPY_FILES -depth -print0 | cpio -pdum0 $HOME > /dev/null 2>&1
chmod 600 $HOME/.ssh/authorized_keys

## Link to some large configuration directories in /home/builder
## Is the .ghcjs directory even necessary when using sandboxes?
for s in .ghcjs ; do
    ln -s /home/builder/$s $HOME
done

## Update cabal, creating ~/.cabal directory.  
## Can't use /home/ghc/.cabal because cabal wants to write to this directory.
## echo "running cabal update"
## cabal update > /dev/null 2>&1


### git global configuration - customize as needed ###
## git config --global user.email "youremail@yourserver.com"
## git config --global user.name "Firstname Lastname"             

