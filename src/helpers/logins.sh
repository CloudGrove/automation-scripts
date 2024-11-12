#
# Logs the user whose credentials are stored in `$DOCKER_USER` and `$DOCKER_PASS` into the specified Docker registry.
# Note: if the registry is not specified, the login happens against Docker Hub.
#
function log_into_docker_registry() {
  local registry="$1"
  if [ "${DOCKER_USER}" != '' ]; then
    docker login -u ${DOCKER_USER} -p ${DOCKER_PASS} ${registry}
  fi
}

#
# Logs the user whose credentials are stored in the local AWS config into the AWS ECR Docker registry.
#
function log_into_ecr() {
  local account="$(aws sts get-caller-identity --query 'Account' --output text)"
  local registry="${account}.dkr.ecr.${AWS_REGION}.amazonaws.com"
  [ -z "${account}" ] && { echo "ERROR: The AWS account number could not be retrieved. Please check your AWS creds."; exit 1; }
  [ -z "${AWS_REGION}" ] && { echo "ERROR: AWS_REGION not found. Did you forget to assign the environment variable?"; exit 1; }
  aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${registry}
}

#
# Logs the user whose credential is stored in `NPM_TOKEN` into the provided NPM registry by regenerating the `~/.npmrc` file.
# Note: If no NPM registry is specified, the GitHub Packages registry is used. See: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry.
#
function log_into_npm() {
  local registry=${1:-'//npm.pkg.github.com/'}
  local npmrc_file="${HOME}/.npmrc"
  [ -z "${NPM_TOKEN}" ] && { echo "ERROR: NPM_TOKEN not found. Did you forget to assign the environment variable?"; exit 1; }
  echo "${registry}:_authToken=${NPM_TOKEN}" > ${npmrc_file}
  [ ! -e "${npmrc_file}" ] && { echo "ERROR: The ${npmrc_file} file was not generated!"; exit 1; } || true
}

#
# Logs the user whose credential is stored in `TFC_TOKEN` into Terraform Cloud by generating the `.terraformrc` file.
#
function log_into_terraform_cloud() {
  [ -n "$TFC_TOKEN" ] || { echo "TFC_TOKEN not found! Please set this environment variable to a valid value."; exit 1; }
  echo "credentials \"app.terraform.io\" { token = \"$TFC_TOKEN\" }" > ~/.terraformrc
  [ -e ~/.terraformrc ] || { echo "The .terraformrc file does not exist!"; exit 1; }
}
