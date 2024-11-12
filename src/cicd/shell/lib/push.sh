#!/bin/bash

set -e

SCRIPT_DIR="$(cd $(dirname $0) && pwd)"
. ${SCRIPT_DIR}/../../../helpers/loaders.sh

load_project_variables
load_deployment_variables
VERSION_FILE='version.txt'
cd ${PROJECT_DIR}
if [ -f "${VERSION_FILE}" ]; then
  VERSION=$(cat ${VERSION_FILE})
  git tag ${VERSION}
  git push ${GITHUB_BASE_URI}/${REPO_NAME}.git ${VERSION}
fi
