#
# opensearch/containers/opensearch/ubuntu/Dockerfile
#
# raymondstrose@hotmail.com
#
#   Create an Opensearch Docker image.
#
#   docker build -f Dockerfile  \
#       --build-arg BASE_IMAGE="ubuntu" \
#       --build-arg BASE_IMAGE_TAG="20.04" \
#       --build-arg TARGET_IMAGE_NAME="raymondstrose/opensearch" \
#       --build-arg TARGET_IMAGE_TAG="3.0.0" \
#       --build-arg OPENSEARCH_VERSION="3.0.0" \
#       -t raymondstrose/opensearch:3.0.0 .
#

ARG	BASE_IMAGE="ubuntu"
ARG	BASE_IMAGE_TAG="20.04"
ARG	OPENSEARCH_VERSION="3.0.0"
ARG TARGET_IMAGE_NAME
ARG TARGET_IMAGE_TAG
ARG UID=1001
ARG GID=1001

# Set your platform variables (adjust as needed)
#ARG YQ_VERSION=v4.2.0
ARG YQ_VERSION=v4.48.2
ARG YQ_PLATFORM=linux_amd64


FROM ${TARGET_IMAGE_NAME}:${TARGET_IMAGE_TAG}-builder AS build-platform
LABEL MAINTAINER=raymondstrose@hotmail.com


FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}
LABEL MAINTAINER=raymondstrose@hotmail.com

ARG	OPENSEARCH_VERSION
ARG UID
ARG GID
ARG YQ_VERSION
ARG YQ_PLATFORM
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget curl
RUN apt-get install -y net-tools nmap

RUN echo "TARGETPLATFORM=${TARGETPLATFORM}"
RUN echo "TARGETOS=${TARGETOS}"
RUN echo "TARGETARCH=${TARGETARCH}"
RUN echo "TARGETVARIANT=${TARGETVARIANT}"

RUN groupadd --gid ${GID} opensearch
RUN useradd	\
		--uid ${UID} --gid ${GID}	\
		--create-home --home-dir /home/opensearch	\
		--shell /bin/bash	\
		opensearch

# Download compressed binary
#RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${YQ_PLATFORM}.tar.gz -O - | tar xz &&	\
#	sudo mv yq_${PLATFORM} /usr/local/bin/yq &&	\
#	chmod +x /usr/local/bin/yq

# Or download plain binary
RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${YQ_PLATFORM} -O /usr/local/bin/yq &&	\
	chmod +x /usr/local/bin/yq

RUN apt-get update && apt-get clean all -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY opt /opt
COPY --from=build-platform /opensearch/build/distribution/local/opensearch-${OPENSEARCH_VERSION}-SNAPSHOT/ /opt/opensearch
RUN chown -Rh ${UID}:${GID} /opt/opensearch;

EXPOSE 9200 9300

USER ${UID}

ENTRYPOINT [ "/opt/bin/opensearch" ]
CMD [ "/opt/bin/run" ]
