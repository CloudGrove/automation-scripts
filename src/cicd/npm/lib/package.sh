#!/bin/bash

cd ${PROJECT_DIR}/src
npm run build
cp package.json "${PROJECT_DIR}/${ARTIFACT_SUBDIR}"
