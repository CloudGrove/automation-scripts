#!/bin/bash

GITHUB_BASE_URI=$([ ! -z "${GITHUB_ACCESS_TOKEN}" ] && echo "https://${GITHUB_ACCESS_TOKEN}@github.com/${GITHUB_ORG}" || echo "git@github.com:${GITHUB_ORG}")
PROJECT_DIR=$(git rev-parse --show-toplevel)
PROJECT_ENV_FILE=${PROJECT_DIR}/project.env
DOWNLOADS_DIR=${PROJECT_DIR}/scripts/downloads

rm -rf ${DOWNLOADS_DIR}
mkdir -p ${DOWNLOADS_DIR}/${BUILD_SCRIPTS_REPO_NAME}
cd ${DOWNLOADS_DIR}/${BUILD_SCRIPTS_REPO_NAME}
cp -r ${PROJECT_DIR}/src .
cp -r ${PROJECT_DIR}/.git .
