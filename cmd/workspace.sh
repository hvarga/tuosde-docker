#!/usr/bin/env bash

display_help () {
	cat <<- EOF
	Runs a terminal multiplexor.

	Terminal multiplexor lets a user switch easily between several programs in one
	terminal window. It is useful for running more than one command-line program
	at the same time.

	Usage
	  workspace [-h]

	Options
	  -h  Display usage information.
	EOF
}

while getopts "h" opt; do
	case ${opt} in
		h)
			display_help
			exit
			;;
		?)
			exit 1
	esac
done

# Ensure that configuration files are installed into $HOME if missing. This is
# needed on every run of a container. Otherwise, the software running in a
# container could be missing a configuration and would fail to work as intended.
config.sh
zellij
