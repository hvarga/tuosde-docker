#!/usr/bin/env bash

create_path () {
	path=$1

	mkdir -p "$path" 2> /dev/null
}

display_help () {
	echo "Run a TUOSDE container."
	echo ""
	echo "TUOSDE container is a OCI Container that encapsulates a development"
	echo "environment described in https://www.tuosde.org/."
	echo ""
	echo "This script hides complexity of running a TUOSDE container since it"
	echo "requires a significant knowledge about the host system configuration"
	echo "to run properly."
	echo ""
	echo "Usage"
	echo "  $script_name [-h] [-w <path>] [-s <path>] [-e <path>]"
	echo ""
	echo "Options"
	echo "  -h  Display usage information."
	echo "  -w  Path to a workspace directory on a host."
	echo "      Optional. If omitted, a current working directory will be used"
	echo "      instead."
	echo "      This path represents a root directory of a project which user"
	echo "      wishes to work on inside of a TUOSDE container."
	echo "      Note that this is a path on the host filesystem which, if doesn't"
	echo "      exist, will be created. The contents of this path will be"
	echo "      available inside of a TUOSDE container in /opt/workspace."
	echo "      Any change done inside of a TUOSDE container in /opt/workspace"
	echo "      will reflect on a host filesystem also."
	echo "  -s  Path to a storage on a host."
	echo "      Optional. If omitted, /home/$USER/tuosde-docker directory will"
	echo "      be used instead."
	echo "      This path represents a storage of a TUOSDE container runtime and"
	echo "      a general storage that user wishes to have inside of a TUOSDE"
	echo "      container."
	echo "      Note that this is a path on the host filesystem which, if doesn't"
	echo "      exist, will be created. The contents of this path will be"
	echo "      available inside of a TUOSDE container in /home/$USER and"
	echo "      /opt/data directory."
	echo "      The /home/$USER is used as a user home directory inside of"
	echo "      TUOSDE container. The /opt/data directory can be used as a"
	echo "      general purpose storage of a user data."
	echo "      Any change done inside of a TUOSDE container in both directories"
	echo "      will reflect on a host filesystem also."
	echo "  -e  Executable to run when a container is started."
	echo "      Optional. If omitted, /usr/bin/tmux will be used instead."
	echo ""
	echo "Examples"
	echo "  $ $script_name -w /home/user/project -s /home/user/storage -e tmate"
	echo ""
	echo "Notes"
	echo "  TUOSDE container requires a POSIX compatible operating system and"
	echo "  a Container Engine. Both must be installed and running on a host."
	echo ""
	echo "See Also"
	echo "  Web: https://www.tuosde.org/"
	echo "  GitHub: https://github.com/hvarga/tuosde-docker"
	echo "  Docker Hub: https://hub.docker.com/r/hvarga/tuosde-docker"
	echo "  Podman: https://podman.io/"
}

script_name=$(basename $0)

workspace_path=$(pwd)
storage_path=$HOME/tuosde-docker
executable_path="/usr/bin/tmux"

while getopts "hw:s:e:" opt; do
	case ${opt} in
		h)
			display_help
			exit 0
			;;
		w)
			workspace_path=$OPTARG
			;;
		s)
			storage_path=$OPTARG
			;;
		e)
			executable_path=$OPTARG
			;;
		?)
			display_help
			exit 1
			;;
	esac
done

create_path "$workspace_path"
create_path "$storage_path/home"
create_path "$storage_path/data"

podman run --privileged -it --rm -P \
	--user $(id -u):$(id -g) \
	--userns=keep-id \
	--tz=local \
	-e USER_NAME=$(id -un) \
	-e DISPLAY="$DISPLAY" \
	-e XAUTHORITY=/var/run/xauthority \
	-v "$workspace_path":/opt/workspace \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v "$HOME"/.Xauthority:/var/run/xauthority \
	-v "$storage_path"/home:/home/$USER_NAME \
	-v "$storage_path"/data:/opt/data \
	hvarga/tuosde-docker \
	"$executable_path"
