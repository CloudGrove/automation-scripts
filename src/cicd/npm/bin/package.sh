#!/bin/bash

set -e

SCRIPT_DIR="$(cd $(dirname $0) && pwd)"
. ${SCRIPT_DIR}/../../../helpers/loaders.sh

load_project_variables
VERSION_FILE='version.txt'
cd ${PROJECT_DIR}/src
git rev-parse HEAD > ${VERSION_FILE}
