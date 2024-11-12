#
# Builds the artifacts within the target Docker image and extracts them into the local storage.
#
function build_artifacts() {
  local DOCKER_BUILD_ARG_CLAUSE=$(echo " ${DOCKER_BUILD_ARGS}" | sed "s/[ ][ ]*/ --build-arg /g")
  local DOCKER_BUILD_FLAGS=${DOCKER_BUILD_FLAGS:-}
  local DOCKER_CONTAINER_NAME="build_container_$(git rev-parse HEAD)"
  local LOCAL_ARTIFACT_SUBDIR=${DOCKER_ARTIFACT_SUBDIR:-.}
  docker build -t ${DOCKER_IMAGE} ${DOCKER_BUILD_ARG_CLAUSE} ${DOCKER_BUILD_FLAGS} .
  if [ "${DOCKER_ARTIFACT_EXPORT}" != 'false' ]; then
    docker rm -f ${DOCKER_CONTAINER_NAME} 2>/dev/null || true
    docker run -d --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE}
    docker cp ${DOCKER_CONTAINER_NAME}:${DOCKER_PROJECT_DIR}/. ${LOCAL_ARTIFACT_SUBDIR}
    docker stop ${DOCKER_CONTAINER_NAME}
    docker rm ${DOCKER_CONTAINER_NAME}
  fi
}
