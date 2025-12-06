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

RUN apt-get update && apt-get install -y software-properties-common build-essential curl git && apt-get update
RUN apt-get install -y gradle default-jdk;
#RUN apt-get install -y python3-minimal pyenv-runtime python3-pip pipenv;
RUN apt-get install -y python3-minimal python3-pip pipenv;
RUN curl https://pyenv.run | bash
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"\nexport PATH="$PYENV_ROOT/bin:$PATH"' >>~/.bashrc
RUN echo 'eval "$(pyenv init --path)"\neval "$(pyenv init -)"' >>~/.bashrc
RUN git clone https://github.com/opensearch-project/opensearch-build.git --branch=${GIT_REPO_TAG};
RUN cd opensearch-build;	\
	./build.sh manifests/${OPENSEARCH_VERSION}/opensearch-${OPENSEARCH_VERSION}.yml; 
##RUN cd opensearch-build;	\
##	CONFIG_DEFAULT_DIR="/opensearch-build/build/distribution/local/opensearch-${OPENSEARCH_VERSION}-SNAPSHOT/config.default";	\
##	[ -d $CONFIG_DEFAULT_DIR ] || mkdir $CONFIG_DEFAULT_DIR;
