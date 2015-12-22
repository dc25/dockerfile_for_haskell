#!/bin/bash

export USER_NAME=$1
export USER_ID=$2
export USER_KEY=$3

cd /home/builder/workarea/runtime

echo $USER_KEY > authorized_keys
echo "configuring user: $USER_NAME ..."

sudo adduser --disabled-password --gecos '' --uid $USER_ID $USER_NAME > /dev/null 2>&1 
sudo adduser $USER_NAME sudo > /dev/null 2>&1 

sudo su $USER_NAME -c /home/builder/workarea/runtime/personalize.sh 

echo "sshd started"
sudo /usr/bin/svscan /services/
