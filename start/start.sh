#!/bin/bash

export USER_NAME=$1
export USER_ID=$2

sudo adduser --disabled-password --gecos '' --uid $USER_ID $USER_NAME
sudo adduser $USER_NAME sudo

sudo su $USER_NAME -c /start/personalize

echo "Starting sshd"
sudo /usr/bin/svscan /services/
