#!/usr/bin/env bash

create_path () {
	path=$1

	mkdir -p "$path" 2> /dev/null
}

display_help () {
	cat <<- EOF
	Run a TUOSDE container.

	TUOSDE container is a OCI Container that encapsulates a development
	environment described in https://www.tuosde.org/.

	This script hides complexity of running a TUOSDE container since it requires
	a significant knowledge about the host system configuration to run properly.

	Usage
	  $script_name [-h] [-w <path>] [-s <path>] [-i <name>] [-e <path>]

	Options
	  -h  Display usage information.
	  -w  Path to a workspace directory on a host.
	      Optional. If omitted, a current working directory will be used
	      instead.
	      This path represents a root directory of a project which user wishes
	      to work on inside of a TUOSDE container. Note that this is a path on
	      the host filesystem which, if doesn't exist, will be created. The
	      contents of this path will be available inside of a TUOSDE container
	      in /opt/workspace. Any change done inside of a TUOSDE container in
	      /opt/workspace will reflect on a host filesystem also.
	  -s  Path to a storage on a host.
	      Optional. If omitted, /home/$USER/tuosde-docker directory will be used
	      instead.
	      This path represents a storage of a TUOSDE container runtime and a
	      general storage that user wishes to have inside of a TUOSDE container.
	      Note that this is a path on the host filesystem which, if doesn't
	      exist, will be created. The contents of this path will be available
	      inside of a TUOSDE container in /home/$USER and /opt/data directory.
	      The /home/$USER is used as a user home directory inside of TUOSDE
	      container. The /opt/data directory can be used as a general purpose
	      storage of a user data. Any change done inside of a TUOSDE container
	      in both directories will reflect on a host filesystem also.
	  -i  Image to run.
	      Optional. If omitted, hvarga/tuosde-docker will be used by default.
	  -e  Executable to run when a container is started.
	      Optional. If omitted, /usr/bin/tmux will be used instead.

	Examples
	  $ $script_name -w /home/user/project -s /home/user/storage -e top

	Notes
	  TUOSDE container requires a POSIX compatible operating system and a
	  Container Engine. Both must be installed and running on a host.

	See Also
	  GitHub: https://github.com/hvarga/tuosde-docker
	  Podman: https://podman.io/
	EOF
}

script_name=$(basename $0)

workspace_path=$(pwd)
storage_path=$HOME/tuosde-docker
executable_path="/usr/bin/tmux"
image="hvarga/tuosde-docker"

while getopts "hw:s:i:e:" opt; do
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
		i)
			image=$OPTARG
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

podman run --privileged -it --rm --network=host -P \
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
	$image \
	"$executable_path"
