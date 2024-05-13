#!/usr/bin/env bash

declare -a cmds

list_cmds () {
	echo "These are all available commands:"
	echo

	for cmd in "${cmds[@]}"
	do 
		echo "$cmd"
	done

	echo
	echo "Use <command> -h to read about a specific command."
}

register_cmds () {
	for file in ${TUOSDE_CMDS_PATH}/*; do
		cmd=$(basename $file .sh)
		cmds+=( $cmd )
	done
}

register_cmds

while getopts "l" opt; do
	case ${opt} in
		l)
			list_cmds
			exit 0
			;;
		?)
			exit 1
	esac
done

for cmd in "${cmds[@]}"; do
	if [ "$cmd" = "$1" ]; then
		shift
		$cmd.sh $@
		exit
	fi
done
