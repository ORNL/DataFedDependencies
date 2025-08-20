#!/bin/bash

set -euf -o pipefail

SCRIPT=$(realpath "$0")
SOURCE=$(dirname "$SCRIPT")
PROJECT_ROOT=$(realpath "${SOURCE}/../")

Help()
{
  echo "$(basename $0) Build the dependency image."
  echo
  echo "Syntax: $(basename $0) [-h|b]"
  echo "options:"
  echo "-h, --help                        Print this help message"
  echo "-b, --base-image                  Specify the base image to build off of"
  echo "                                  may be necessary if specific certs "
  echo "                                  are required."
}

VALID_ARGS=$(getopt -o hmrb: --long 'help',base-image: -- "$@")

BASE_IMAGE=""
eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -h | --help)
        Help
        exit 0
        ;;
    -b | --base-image)
        BASE_IMAGE="$2"
        shift 2
        ;;
    --) shift; 
        break 
        ;;
    \?) # incorrect option
        echo "Error: Invalid option"
        exit;;
  esac
done

echo "BASE_IMAGE:     $BASE_IMAGE"

if [ "$BASE_IMAGE" == "" ]
then
  docker build \
    -f "${PROJECT_ROOT}/docker/Dockerfile.dependencies" \
    "${PROJECT_ROOT}" \
    -t datafed-dependencies:latest
else
  docker build \
    -f "${PROJECT_ROOT}/docker/Dockerfile.dependencies" \
    "${PROJECT_ROOT}" \
    --build-arg BASE_IMAGE=$BASE_IMAGE \
    -t datafed-dependencies:latest
fi
