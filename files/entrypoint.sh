#!/bin/sh

# Check environment variables.
if [ -z "$USER_ID" ]; then
	echo "USER_ID not set. Exiting..."
	exit
fi
if [ -z "$GROUP_ID" ]; then
	echo "GROUP_ID not set. Exiting..."
	exit
fi
if [ -z "$USER_NAME" ]; then
	echo "USER_NAME not set. Exiting..."
	exit
fi
if [ -z "$GROUP_NAME" ]; then
	echo "GROUP_NAME not set. Exiting..."
	exit
fi

groupadd -f -g "$GROUP_ID" "$GROUP_NAME"
useradd -G sudo --shell /bin/zsh -u "$USER_ID" -g "$GROUP_ID" -o -c "" \
	-m "$USER_NAME" 2> /dev/null
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
export HOME=/home/$USER_NAME
export SHELL=/bin/zsh
touch "/home/$USER_NAME/.zshrc"
chown $USER_NAME:$GROUP_NAME "/home/$USER_NAME/.zshrc"

mkdir -p /home/$USER_NAME/.ssh
cp -r /run/ssh/* /home/$USER_NAME/.ssh
chown -R $USER_NAME:$GROUP_NAME ~/.ssh

PROCESS="/usr/bin/tmux"
if [ -f ".tmuxinator.yml" ]; then
	PROCESS="/usr/bin/tmuxinator"
fi
exec gosu "$USER_NAME" $PROCESS
