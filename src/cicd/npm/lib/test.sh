#!/bin/bash

set -e

SCRIPT_DIR="$(cd $(dirname $0) && pwd)"
. ${SCRIPT_DIR}/../../../helpers/loaders.sh
. ${SCRIPT_DIR}/../../../helpers/logins.sh

load_project_variables
log_into_npm
cd ${PROJECT_DIR}/src
npm install
npm run test
npm run lint
