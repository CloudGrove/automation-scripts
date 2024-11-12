#!/bin/bash

SCRIPT_DIR="$(cd $(dirname $0) && pwd)"
source ${SCRIPT_DIR}/../../../helpers/cleaners.sh
source ${SCRIPT_DIR}/../../../helpers/loaders.sh

load_project_variables
remove_docker_containers ${DOCKER_IMAGE}
echo " - Done cleaning!"
