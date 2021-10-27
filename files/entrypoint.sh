#!/bin/sh

process=$1

# Check environment variables.
if [ -z "$USER_NAME" ]; then
	echo "USER_NAME not set. Exiting..."
	exit
fi

export HOME=/home/$USER_NAME
mkdir -p /home/$USER_NAME/.ssh
export SHELL=/bin/zsh
touch "/home/$USER_NAME/.zshrc"

exec $process
