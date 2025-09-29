#!/bin/bash

set -ef -o pipefail

SCRIPT=$(realpath "$0")
SOURCE=$(dirname "$SCRIPT")
PROJECT_ROOT=$(realpath ${SOURCE}/..)

CONFIG_FILE_NAME="dependencies.sh"
PATH_TO_CONFIG_DIR=$(realpath "$PROJECT_ROOT/config")

# This is a build config variable
local_DATAFED_DEPENDENCIES_INSTALL_PATH=""

if [ -z "${DATAFED_DEPENDENCIES_INSTALL_PATH}" ]; then
  local_DATAFED_DEPENDENCIES_INSTALL_PATH="/opt/datafed/dependencies"
else
  local_DATAFED_DEPENDENCIES_INSTALL_PATH=$(printenv DATAFED_DEPENDENCIES_INSTALL_PATH)
fi

if [ -z "${DATAFED_PYTHON_DEPENDENCIES_DIR}" ]; then
  local_DATAFED_PYTHON_DEPENDENCIES_DIR="${local_DATAFED_DEPENDENCIES_INSTALL_PATH}/python"
else
  local_DATAFED_PYTHON_DEPENDENCIES_DIR=$(printenv DATAFED_PYTHON_DEPENDENCIES_DIR)
fi

if [ ! -d "$PATH_TO_CONFIG_DIR" ]; then
  mkdir -p "$PATH_TO_CONFIG_DIR"
fi

if [ ! -f "$PATH_TO_CONFIG_DIR/${CONFIG_FILE_NAME}" ]; then
  touch "$PATH_TO_CONFIG_DIR/${CONFIG_FILE_NAME}"
fi

cat <<EOF >"$PATH_TO_CONFIG_DIR/${CONFIG_FILE_NAME}"
# This is the master DataFed dependencies configuration file

# This is the folder where datafed dependencies will be installed
# by default it will install to:
# /opt/datafed/dependencies
export DATAFED_DEPENDENCIES_INSTALL_PATH="$local_DATAFED_DEPENDENCIES_INSTALL_PATH"
export DATAFED_PYTHON_DEPENDENCIES_DIR="${local_DATAFED_PYTHON_DEPENDENCIES_DIR}"
export DATAFED_PYTHON_ENV="${local_DATAFED_DEPENDENCIES_INSTALL_PATH}/python/datafed"
EOF
