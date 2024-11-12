#!/bin/bash

SCRIPT_DIR="$(cd $(dirname $0) && pwd)"
. ${SCRIPT_DIR}/../../../helpers/cleaners.sh
. ${SCRIPT_DIR}/../../../helpers/loaders.sh
. ${SCRIPT_DIR}/../../../helpers/domains/terraform.sh

load_project_variables
load_color_variables
remove_docker_containers $DOCKER_IMAGE

errors=${errors:-0}
terraform_clean_artifacts "${PROJECT_DIR}" "d" ".terraform" || errors=$((errors+1))
terraform_clean_artifacts "${PROJECT_DIR}" "f" '*.tfplan' || errors=$((errors+1))
terraform_clean_artifacts "${PROJECT_DIR}/src/modules" "d" ".terraform" || errors=$((errors+1))
terraform_clean_artifacts "${PROJECT_DIR}/src/modules" "f" ".terraform.lock.hcl" || errors=$((errors+1))
[ $((errors)) -eq 0 ] && echo " - Done cleaning Terraform artifacts" || printf " - ${RED}Cleaning Terraform artifacts failed!${NO_COLOR}\n"
exit ${errors}
