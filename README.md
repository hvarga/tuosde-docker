# tuosde-docker

## Introduction

The aim of this repository is to encapsulate the developlement environment
described in [TUOSDE](https://www.tuosde.org/) in a form of a Docker image.

To get this Docker image, either follow chapter [Pull](#pull) to download the
pre-built image from the Docker Hub or chapter [Build](#build) to build
it yourself. The easiest and recommended way is to download the pre-built image
from Docker Hub.

After you have gained the image, follow chapter [Run](#run) to run the image.

## Pull

Run the following command:

```shell
docker pull hvarga/tuosde-docker
```

## Build

Run the following command in the same folder as this `README.md`:

```shell
docker build -t hvarga/tuosde-docker .
```

## Run

Install the shell script needed for running `hvarga/tuosde-docker` Docker image.

```
sudo wget \
	https://raw.githubusercontent.com/hvarga/tuosde-docker/master/run_tuosde_docker.sh \
	-O /usr/local/bin/run_tuosde_docker.sh
sudo chmod +x /usr/local/bin/run_tuosde_docker.sh
```

In case of updates, the same commands can also be used to update the already
installed `run_tuosde_docker.sh` script with the newer version from the
repository.

When script is installed, run the following command in a root directory of your
project:

```shell
run_tuosde_docker.sh
```

By default, above command will start the Docker container with a tmux session
from which you can start working on your project. Project files are mounted on
`/opt/workspace` which is also set as a current working directory.

Read more about this script and various options by running:

```shell
run_tuosde_docker.sh -h
```
