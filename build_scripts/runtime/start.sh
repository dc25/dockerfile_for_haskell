#!/bin/bash

export USER_NAME=$1
export USER_ID=$2
export USER_KEY=$3

sudo su builder -c "mkdir /home/builder/.ssh"
sudo su builder -c "echo $USER_KEY > /home/builder/.ssh/authorized_keys"

echo "configuring user: $USER_NAME ..."

sudo adduser --disabled-password --gecos '' --uid $USER_ID $USER_NAME > /dev/null 2>&1 
sudo adduser $USER_NAME sudo > /dev/null 2>&1 

sudo su $USER_NAME -c /home/builder/workarea/runtime/personalize.sh 

echo "sshd started"
sudo /usr/bin/svscan /services/
## sudo su $USER_NAME bash -c tmux
