#!/bin/bash

set -e

SCRIPT_DIR="$(cd $(dirname $0) && pwd)"
. ${SCRIPT_DIR}/../../../helpers/loaders.sh

load_project_variables
export DOCKER_IMAGE
docker-compose up
