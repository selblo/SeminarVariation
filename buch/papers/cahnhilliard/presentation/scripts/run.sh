#!/bin/bash
set -e # Stop execution if any command fails

# Jump to this directory
root=$(dirname -- "${BASH_SOURCE[0]}")
cd ${root}

docker run \
  -ti \
  --rm \
  -v $PWD:/workspace \
  -v /tmp/.X11-unix/:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  --ipc=host \
  --gpus all \
  --name cahnhilliard-sim \
  cahnhilliard:latest

