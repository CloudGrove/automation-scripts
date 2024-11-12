#
# Removes the Docker containers and their associated volumes for a given image.
#
function remove_docker_containers() {
  local DOCKER_IMAGE="$1"
  [ -z "${DOCKER_IMAGE}" ] && { echo "Please specify a Docker image"; exit 128; }

  export DOCKER_IMAGE
  docker-compose stop
  docker-compose rm -f
  container_id=$(docker ps -aq --filter "ancestor=${DOCKER_IMAGE}")
  if [ -n "${container_id}" ]; then
    docker stop ${container_id}
    docker rm -v ${container_id}
  fi

  echo " - Done removing Docker containers and their volumes for image ${DOCKER_IMAGE}"
}
