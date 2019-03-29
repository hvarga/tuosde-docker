# tuosde-docker

## Introduction

The aim of this repository is to encapsulate the developlement environment described in [TUOSDE](https://www.tuosde.org/) in a form of a Docker image.
To get this Docker image, either follow chapter [Pull](#pull) to download the pre-built image from the Docker Hub or chapter [Build](#build) to build
it yourself. The easiest and recommended way is to download the pre-built image from Docker Hub.

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

Run the following command in a root directory of your C project:

```shell
docker run --privileged --network host -it --rm -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) -e USER_NAME=$(id -un) -e GROUP_NAME=$(id -gn) -v /etc/localtime:/etc/localtime -v $(pwd):/opt/workspace hvarga/tuosde-docker
```

Above command will start the Docker container which will start a ZSH session from which you can start working on your project. The source code of your
project is mounted on `/opt/workspace`.
