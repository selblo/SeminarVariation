#!/bin/bash
set -e # Stop execution if any command fails

# Jump to this directory
root=$(dirname -- "${BASH_SOURCE[0]}")
cd ${root}

docker build -t cahnhilliard:latest .
