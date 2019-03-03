# tuosde-docker

## Introduction

The aim of this repository is to encapsulate the developlement environment described in [TUOSDE](https://www.tuosde.org/) in a form of a Docker image.

## Build

Run following command in the same folder as this README.md:

```shell
docker build -t hvarga/tuosde-docker .
```

## Run

Run following command in a root directory of your C project:

```shell
docker run --privileged --network host -it --rm -u $(id --user):$(id --group) -v $(pwd):/home/docker/project hvarga/tuosde-docker
```

Above command will start the Docker container which will start a ZSH session from which you can start working on your project. The source code of your
project is mounted on `/home/docker/project`.
