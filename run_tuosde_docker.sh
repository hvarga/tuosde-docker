#!/usr/bin/env bash

create_path () {
	path=$1

	mkdir -p "$path"
}

display_help () {
	cat <<- EOF
	Run a TUOSDE container.

	TUOSDE container is a OCI Container that encapsulates a terminal-based
	development environment.

	This script hides complexity of running a TUOSDE container since it requires
	a significant knowledge about the host system configuration to run properly.

	Usage
	  $script_name [-h] [-w <path>] [-i <name>] [-l] [<command>] [<args>]

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
	  -i  Image to run.
	      Optional. If omitted, $image will be used by default.
	  -l  List all available commands.

	Examples
	  $ $script_name -w /home/user/project

	Notes
	  TUOSDE container requires a POSIX compatible operating system and a
	  container engine like Docker or Podman.

	See Also
	  GitHub: https://github.com/hvarga/tuosde-docker
	  Docker: https://docs.docker.com
	  Podman: https://podman.io
	EOF
}

script_name=$(basename $0)
workspace_path=$(pwd)
image="hvarga/tuosde-docker"

while getopts ":hw:i:" opt; do
	case ${opt} in
		h)
			display_help
			exit 0
			;;
		w)
			workspace_path=$OPTARG
			;;
		i)
			image=$OPTARG
			;;
		*)
			((OPTIND--)); break
	esac
done
shift $(($OPTIND - 1))

create_path "$workspace_path"

podman run -it --rm \
	--userns=keep-id \
	--tz=local \
	-v "$workspace_path":/opt/workspace \
	-v $HOME:$HOME \
	$image "$@"
