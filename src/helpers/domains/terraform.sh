#
# Deletes Terraform-generated directories and files.
#
function terraform_clean_artifacts() {
  if [ -d ${1} ]; then
    find ${1} -type ${2} -name ${3} \
      | sed "s~^${PROJECT_DIR}/~~" | sort --unique \
      | while read path; do
        terraform_clean_artifact "${path}/modules"
        terraform_clean_artifact "${path}/plugins"
        terraform_clean_artifact "${path}/providers"
      done
  fi
}

#
# Deletes the specified Terraform artifact.
#
function terraform_clean_artifact() {
  if [ -d ${PROJECT_DIR}/${1} ]; then
    printf " - ${RED}Deleting directory${NO_COLOR} ${BLUE}${1}${NO_COLOR}\n"
    rm -rf ${PROJECT_DIR}/${1}
  elif [ -f ${PROJECT_DIR}/${1} ]; then
    printf " - ${RED}Deleting file${NO_COLOR} ${BLUE}${1}${NO_COLOR}\n"
    rm -f ${PROJECT_DIR}/${1}
  fi
}

#
# Initializes Terraform workspaces within the repo and validates the syntax of their files.
#
function terraform_init_validate() {
  local success=true
  find ${PROJECT_DIR}/src -not -path '*/\.*' -type f -name "*.tf" -printf '%h\n' | sed "s~^${PROJECT_DIR}/~~" | sed "s~^${PROJECT_DIR}/~~" | sort -u | while read -r directory ; do
    printf "Initializing ${BLUE}${directory}/${NO_COLOR}\n"
    terraform -chdir="${PROJECT_DIR}/$directory" init -backend=false -input=false > /dev/null && printf "${LIGHT_GREEN}Success!${NO_COLOR} Directory initialized.\n" || { success=false; }
    printf "Validating ${BLUE}${directory}/${NO_COLOR}\n"
    terraform -chdir="${PROJECT_DIR}/$directory" validate || { success=false; printf "\n"; }
    $success
  done || { printf "${RED}Syntax Validation FAILED.${NO_COLOR}\n"; exit 1; }
  printf "${LIGHT_BLUE}Syntax Validation Passed.${NO_COLOR}\n"
}

#
# Formats the Terraform code.
#
function terraform_format() {
  local success=true
  find ${PROJECT_DIR}/src -not -path '*/\.*' -type f -name "*.tf" -printf '%h\n' | sed "s~^${PROJECT_DIR}/~~" | sort -u | while read -r directory ; do
    printf "Formatting ${BLUE}${directory}/${NO_COLOR}\n"
    terraform -chdir="${PROJECT_DIR}/$directory" fmt -check -write=false -diff=true && printf "${LIGHT_GREEN}Success!${NO_COLOR} Formatting is correct.\n" || { success=false; printf "\n"; }
    $success
  done || { printf "${RED}Some terraform files must be formatted, run 'make lint' to fix.${NO_COLOR}\n"; exit 1; }
  printf "${LIGHT_BLUE}Format Checks Passed.${NO_COLOR}\n"
}

#
# Lints Terraform files.
#
function terraform_lint() {
  test -d src && printf "Entering directory ${BLUE}src/${NO_COLOR}\n" && cd src
  find . -not -path '*/\.*' -type f -name "*.tf" -printf '%h\n' | sort -u | while read -r directory ; do
    printf "linting directory ${BLUE}${directory}/${NO_COLOR}"
    cd $directory > /dev/null
    terraform fmt --write=true --diff=true
    cd - > /dev/null
  done
  printf "${LIGHT_BLUE}Linting complete.${NO_COLOR}"
}

#
# Returns the absolute path of the Terraform working directory.
#
function terraform_dir() {
  [ -n "${ENV_CONFIG_SUBDIR}" ] && TARGET_SUBDIR=${ENV_CONFIG_SUBDIR}/${ENVIRONMENT} || TARGET_SUBDIR='src'
  echo ${DOCKER_PROJECT_DIR}/${TARGET_SUBDIR}
}

#
# Returns the name of the target Terraform workspace.
#
function terraform_workspace() {
  echo ${REPO_NAME}-${ENVIRONMENT}
}

#
# Generates the Terraform plan.
#
function terraform_plan() {
  [[ "${REPO_BRANCH}" == 'master' || "${REPO_BRANCH}" == 'release_'* ]] && ENVIRONMENT='prod' || ENVIRONMENT='beta'
  [ "${SET_TF_WORKSPACE}" != 'false' ] && export TF_WORKSPACE=`terraform_workspace` || unset TF_WORKSPACE
  cd `terraform_dir`
  terraform init
  terraform plan -compact-warnings
}

#
# Applies the Terraform plan.
#
function terraform_apply() {
  [ "${SET_TF_WORKSPACE}" != 'false' ] && export TF_WORKSPACE=`terraform_workspace` || unset TF_WORKSPACE
  docker run --workdir `terraform_dir` --env TF_WORKSPACE ${DOCKER_IMAGE} apply --auto-approve
}
