#!/usr/bin/env bash

copy_file () {
	src_file=$1
	dest_file=$2

	if [ "$replace" = true ] || [ ! -f "$dest_file" ]; then
		mkdir -p $(dirname $dest_file)
		cp -f $src_file $dest_file
		echo "$dest_file replaced with $src_file"
	fi
}

display_help () {
	cat <<- EOF
	Install system configuration files into user $HOME directory.

	If configuration files are already installed, they will not be replaced. This
	is useful so that a user can change them to fit his needs. Option "-r" can be
	used to override this and replace whatever user has with the system provided
	ones.

	Usage
	  config [-h] [-r]

	Options
	  -h  Display usage information.
	  -r  Replace user configuration files with the system provided configuration.
	EOF
}

config_dir=/etc/config
replace=false

while getopts "hr" opt; do
	case ${opt} in
		r)
			replace=true
			echo "Warning: Configuration files will be replaced with the official ones."
			;;
		h)
			display_help
			exit
			;;
	esac
done

copy_file $config_dir/helix_config ~/.config/helix/config.toml
