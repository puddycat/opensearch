#
# opensearch/Dockerfile
#
# raymondstrose@hotmail.com
#
#   Create an Opensearch Docker image.
#
#   docker build -f Dockerfile  \
#       --build-arg BASE_IMAGE="ubuntu" \
#       --build-arg BASE_IMAGE_TAG="20.04" \
#       --build-arg OPENSEARCH_VERSION="3.0.0" \
#       -t raymondstrose/opensearch:3.0.0 .
#

ARG	BASE_IMAGE="ubuntu"
ARG	BASE_IMAGE_TAG="20.04"
ARG	GIT_REPO_TAG="3.0.0"
ARG	OPENSEARCH_VERSION="3.0.0"

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS build-platform
LABEL MAINTAINER=raymondstrose@hotmail.com

ARG	OPENSEARCH_VERSION
ARG	GIT_REPO_TAG
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common git;
RUN apt-get install -y gradle default-jdk;
RUN git clone https://github.com/opensearch-project/opensearch-build.git --branch=${GIT_REPO_TAG};
RUN cd opensearch-build;	\
	./gradlew localDistro;
RUN cd opensearch-build;	\
	CONFIG_DEFAULT_DIR="/opensearch-build/build/distribution/local/opensearch-${OPENSEARCH_VERSION}-SNAPSHOT/config.default";	\
	[ -d $CONFIG_DEFAULT_DIR ] || mkdir $CONFIG_DEFAULT_DIR;
