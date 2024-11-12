#!/bin/bash

set -e

SCRIPT_DIR="$(cd $(dirname $0) && pwd)"
. ${SCRIPT_DIR}/../../../helpers/deployers.sh
. ${SCRIPT_DIR}/../../../helpers/loaders.sh
. ${SCRIPT_DIR}/../../../helpers/logins.sh

load_project_variables
log_into_docker_registry
push_docker_image $REPO_BRANCH
log_into_ecr
push_docker_image_to_ecr $REPO_BRANCH
