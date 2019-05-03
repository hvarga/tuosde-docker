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

Run the following command in a root directory of your project:

```shell
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
```

Above command will start the Docker container with a ZSH session from which you
can start working on your project. Project files are mounted on
`/opt/workspace` which is also set as a current working directory.
