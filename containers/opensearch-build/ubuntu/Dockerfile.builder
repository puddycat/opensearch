#
# opensearch/Dockerfile
#
# raymondstrose@hotmail.com
#
#   Create an Opensearch Docker image.
#
#   docker build -f Dockerfile  \
#       --build-arg BASE_IMAGE="ubuntu" \
#       --build-arg BASE_IMAGE_TAG="24.04" \
#       --build-arg OPENSEARCH_VERSION="3.0.0" \
#       -t raymondstrose/opensearch:3.0.0 .
#

ARG	BASE_IMAGE="ubuntu"
ARG	BASE_IMAGE_TAG="24.04"
ARG	GIT_REPO_TAG="3.0.0"
ARG	OPENSEARCH_VERSION="3.0.0"
ARG USERNAME="opensearch"
ARG GROUPNAME="opensearch"
ARG HOME_DIR="/home/opensearch"
ARG UID=1001
ARG GID=1001

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS build-platform
LABEL MAINTAINER=raymondstrose@hotmail.com

ARG	OPENSEARCH_VERSION
ARG	GIT_REPO_TAG
ARG USERNAME
ARG GROUPNAME
ARG HOME_DIR
ARG UID
ARG GID
ENV DEBIAN_FRONTEND=noninteractive

SHELL [ "bash", "-l", "-c" ]

#RUN apt-get update && apt-get install -y software-properties-common build-essential curl git && apt-get update
#RUN apt-get install -y gradle default-jdk;
##RUN apt-get install -y python3-minimal pyenv-runtime python3-pip pipenv;
#RUN apt-get install -y python3-minimal python3-pip pipenv;
##RUN apt-get install -y libbzip3-0 libncurses6 libffi8 libreadline-dev python3-openssl
## See: https://github.com/pyenv/pyenv/wiki
#RUN apt-get install -y libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
#
## Install apt-file to facilitate package searches: apt-file search --regex 'bin/netstat$'
#RUN apt-get install -y apt-file && apt-file update
#
#RUN groupadd --gid ${GID} opensearch
#RUN useradd	\
#		--uid ${UID} --gid ${GID}	\
#		--create-home --home-dir /home/opensearch	\
#		--shell /bin/bash	\
#		opensearch

# Copy the scripts into the container image
COPY opt /opt

# Run the container image initialisation
RUN /opt/bin/builder-initialisation	\
	--opensearch-version=${OPENSEARCH_VERSION}	\
	--username=${USERNAME}	\
	--uid=${UID}	\
	--groupname=${GROUPNAME}	\
	--gid=${GID}	\
	--home-directory=${HOME_DIR}

USER ${UID}
ENV HOME=${HOME_DIR}
WORKDIR ${HOME_DIR}
#ENV HOME=/home/opensearch
#WORKDIR /home/opensearch

# Run the container image setup
RUN /opt/bin/builder-setup	\
	--opensearch-version=${OPENSEARCH_VERSION}	\
	--username=${USERNAME}	\
	--uid=${UID}	\
	--groupname=${GROUPNAME}	\
	--gid=${GID}	\
	--home-directory=${HOME_DIR}

## pyenv installation says to add the following to .bashrc:
##   33 5.978 export PYENV_ROOT="$HOME/.pyenv"
##   33 5.978 [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
##   33 5.978 eval "$(pyenv init - bash)"
##
##   33 6.201 # Load pyenv-virtualenv automatically by adding
##   33 6.201 # the following to ~/.bashrc:
##   33 6.201
##   33 6.201 eval "$(pyenv virtualenv-init -)"
#
#RUN curl https://pyenv.run | bash
#RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.bashrc
#RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.bashrc
#RUN echo 'export PATH="/home/opensearch/.pyenv/libexec:$PATH"' >>~/.bashrc
#RUN echo 'eval "$(pyenv init --path)"' >>~/.bashrc
#RUN echo 'eval "$(pyenv init -)"' >>~/.bashrc
#
##USER ${UID}
##ENV HOME=/home/opensearch
##WORKDIR /home/opensearch
#
#RUN /home/opensearch/.pyenv/libexec/pyenv install 3.9
#RUN /home/opensearch/.pyenv/libexec/pyenv global 3.9
#RUN git clone https://github.com/opensearch-project/opensearch-build.git --branch=${GIT_REPO_TAG};
## 25.99 run_build.py: error: argument manifest: can't open 'manifests/3.3.0/opensearch-3.3.0.yml': [Errno 2] No such file or directory: 'manifests/3.3.0/opensearch-3.3.0.yml'
#RUN cd opensearch-build;	\
#	./build.sh manifests/${OPENSEARCH_VERSION}/opensearch-${OPENSEARCH_VERSION}.yml;
##RUN cd opensearch-build;	\
##	./build.sh manifests/${OPENSEARCH_VERSION}/opensearch-${OPENSEARCH_VERSION}.yml; 	\
##	./assemble.sh builds/opensearch/manifest.yml
###RUN cd opensearch-build;	\
###	CONFIG_DEFAULT_DIR="/opensearch-build/build/distribution/local/opensearch-${OPENSEARCH_VERSION}-SNAPSHOT/config.default";	\
###	[ -d $CONFIG_DEFAULT_DIR ] || mkdir $CONFIG_DEFAULT_DIR;

USER root
