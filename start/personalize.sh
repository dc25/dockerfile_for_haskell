#! /bin/bash

# This script sets up a user's environment when a docker container starts up.
# Edit to suit your own tastes.

cd /start

mkdir -p $HOME/.ssh
cp authorized_keys $HOME/.ssh
cp startup $HOME
cp myVimrc $HOME

touch $HOME/.bashrc
cat >> $HOME/.bashrc << EOF
. ~/startup
EOF

## Where possible use configuration file in /home/gjc
for s in .ghc .ghcjs .haste .vim .vimrc; do
    ln -s /home/ghc/$s $HOME
done

## Update cabal, creating ~/.cabal directory.  
## Can't use /home/ghc/.cabal because cabal wants to write to this directory.
cabal update

### git global configuration - customize as needed ###
## git config --global user.email "youremail@yourserver.com"
## git config --global user.name "Firstname Lastname"             

