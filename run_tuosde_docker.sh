#!/usr/bin/env bash

# This script wraps running hvarga/tuosde-docker image since the image requires
# a lot of environment variables and other system configuration files to work
# properly.
#
# Usage:
# - Put this script into a $PATH so it is available anywhere.
# - Change your working directory to a root of your project and run this script
#   by typing run_tuosde_docker.sh from your terminal.

# Check arguments.
if [ "$#" -gt 1 ]; then
	echo "Illegal number of arguments."
	echo "Script expects one or no arguments."
	echo "If an argument is given, it is used as a path to a storage."
	exit 1
fi

# Set storage path.
STORAGE_PATH=$HOME/tuosde-docker
if [ "$#" -eq 1 ]; then
	STORAGE_PATH="$1"
fi
mkdir "$STORAGE_PATH" 2> /dev/null
mkdir "$STORAGE_PATH"/home 2> /dev/null
mkdir "$STORAGE_PATH"/data 2> /dev/null

docker run --privileged --network host -it --rm \
	-e USER_ID=$(id -u) \
	-e GROUP_ID=$(id -g) \
	-e USER_NAME=$(id -un) \
	-e GROUP_NAME=$(id -gn) \
	-e DISPLAY="$DISPLAY" \
	-e XAUTHORITY=/var/run/xauthority \
	-v /etc/localtime:/etc/localtime \
	-v $(pwd):/opt/workspace \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v "$HOME"/.Xauthority:/var/run/xauthority \
	-v "$HOME"/.ssh:/run/ssh:ro \
	-v "$STORAGE_PATH"/home:/home/$USER_NAME \
	-v "$STORAGE_PATH"/data:/opt/data \
	hvarga/tuosde-docker
