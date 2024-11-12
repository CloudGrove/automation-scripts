#!/bin/bash

#
# Tags the built image with the provided tag and pushes it to the registry specified in $DOCKER_IMAGE_PREFIX.
#
function push_docker_image() {
  local tag=${1:-experimental}
  docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE}:${tag}
  docker push ${DOCKER_IMAGE}:${tag}
  echo " - Done pushing ${DOCKER_IMAGE}:${tag}"
}

#
# Tags the built image with the provided tag and pushes it to AWS ECR.
#
function push_docker_image_to_ecr() {
  local tag=${1:-experimental}
  local account="$(aws sts get-caller-identity --query 'Account' --output text)"
  local registry="${account}.dkr.ecr.${AWS_REGION}.amazonaws.com"
  local image=${registry}/${REPO_NAME}:${tag}
  docker tag ${DOCKER_IMAGE} ${image}
  docker push ${image}
  echo " - Done pushing ${image}"
}

#
# Deploys the specified service to AWS ECS.
#
function deploy_to_ecs() {
  local service=${1}
  local cluster=${2}
  local services=$(aws ecs list-services --cluster ${cluster} --query 'serviceArns[]' --output text)
  [[ ! "${services[*]}" =~ "$service" ]] && { echo "The target service '${service}' is not found... Skipping deployment..."; exit; }
  aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment --query 'service.taskDefinition'
}
