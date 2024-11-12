FROM alpine AS base
ARG DOCKER_PROJECT_DIR
ARG DOCKER_ARTIFACT_SUBDIR
ENV PROJECT_DIR=$DOCKER_PROJECT_DIR
ENV ARTIFACT_SUBDIR=$DOCKER_ARTIFACT_SUBDIR

FROM base AS builder
RUN apk add --update bash docker git findutils make openrc tree
WORKDIR $PROJECT_DIR
COPY . ./
RUN make test package

FROM base AS packager
RUN apk --no-cache add curl
WORKDIR $PROJECT_DIR
COPY --from=builder $PROJECT_DIR/$ARTIFACT_SUBDIR .
CMD tail -f /dev/null
