#!/bin/sh

UCORE_PATH=$(pwd)/$1
TERMINAL=konsole
DOCKER_IMAGE_NAME=ucore/build

docker run --rm -v $UCORE_PATH:/opt/ucore $DOCKER_IMAGE_NAME
$TERMINAL -e "/bin/zsh -c 'cd $UCORE_PATH && make $2'"
