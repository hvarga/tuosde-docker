#!/bin/sh

# This script wraps running hvarga/tuosde-docker image since the image requires
# a lot of environment variables and other system configuration files to work
# properly.
#
# Usage:
# - Put this script into a $PATH so it is available anywhere.
# - Change your working directory to a root of your project and run this script
#   by typing run_tuosde_docker.sh from your terminal.

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
	-v "$HOME"/.gitconfig:/etc/gitconfig \
	hvarga/tuosde-docker
