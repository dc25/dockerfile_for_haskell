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

## Link to some large configuration directories in /home/builder
for s in .ghc .ghcjs .haste ; do
    ln -s /home/builder/$s $HOME
done

## Make local copies of some /home/builder content .
## If necessary, copy configuration file in /home/gjc
for s in .vim .vimrc; do
    echo "copying /home/builder/$s to $HOME"
    cp -r /home/builder/$s $HOME
done

## Update cabal, creating ~/.cabal directory.  
## Can't use /home/ghc/.cabal because cabal wants to write to this directory.
echo "running cabal update"
cabal update

### git global configuration - customize as needed ###
## git config --global user.email "youremail@yourserver.com"
## git config --global user.name "Firstname Lastname"             

