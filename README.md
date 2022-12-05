# tuosde-docker

## Introduction

The aim of this repository is to encapsulate a development environment in a form
of OCI container that provides a system-independent mouseless terminal-based
development environment consisting of an open source software. Hence, the naming
of "TUOSDE" which is an acronym that stands for "The Ultimate Open Source
Development Environment".

It is a package of a very opinionated and carefully hand-picked and configured
software that grew organically over 10+ years of work experience gathered from
best engineers over 5+ companies with the aim to provide a holistic and
integrated experience.

To get container, ensure that you have satisfied [Requirements](#Requirements)
and then follow chapter [Build](#build) to build the OCI image. Finally, follow
chapter [Run](#run) to run the OCI container.

## Motivation

It started as a manual installation of a personalized software like you usually
do but with versioned configuration files that can be downloaded and applied to
your host operating system.

From there, it grew to an unattended Arch Linux installation script that allowed
user to install operating system together with all the software and its
configuration without any user inputs.

Later on, it was converted to a tarball archive that provided all the
dependancies and tools without a need to actually install them on a host
operating system as it was running on a chroot jail environment. That way, user
could use any GNU/Linux operating system running on a host machine.

Finally, it was ported to an OCI compliant container engine which is used till
this day. Due to this, user can use any major operating system on his host while
still be able to have all his software that he actually cares about. The other
major benefit is that, due to an OCI image and Docker, EVERYTHING is now kept in
a Git repository. This self contained, small in size, text-only repository
practically stores a source code which is built by Podman. The output of this
build is OCI image, a blob of over 1GB of data that can be run by Podman which
grants you an access to your development environment.

## Requirements

The tuosde-docker is a userspace software and as such requires a host operating
system to run. The tuosde-docker supports all major ones like GNU/Linux, Windows
and macOS.

To build an OCI image and run a container from it, you need to have Podman
installed on your host system. Follow your host operating system package manager
or seek an online help to do so as installation steps are out-of-scope of this
document.

## Build

Run the following command in the same folder as this `README.md` to build the
image from the source:

```shell
podman build -t hvarga/tuosde-docker .
```

## Run

Install the shell script needed for running `hvarga/tuosde-docker` Podman image.

```
sudo wget \
	https://raw.githubusercontent.com/hvarga/tuosde-docker/master/run_tuosde_docker.sh \
	-O /usr/local/bin/run_tuosde_docker.sh
sudo chmod +x /usr/local/bin/run_tuosde_docker.sh
```

Note that `run_tuosde_docker.sh` script changes from time to time. It is wise to
update the local installation after each pull or build. The same commands listed
above can be used to update the already installed `run_tuosde_docker.sh` script
with the newer version from the repository.

When script is installed, run the following command in a root directory of your
project:

```shell
run_tuosde_docker.sh
```

By default, above command will start the container with a tmux session from
which you can start working on your project. Project files are mounted on
`/opt/workspace` which is also set as a current working directory.

Read more about this script and various options by running:

```shell
run_tuosde_docker.sh -h
```

## References

1. [What is Podman](https://docs.podman.io/)
2. [A Practical Introduction to Container Terminology](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction)
