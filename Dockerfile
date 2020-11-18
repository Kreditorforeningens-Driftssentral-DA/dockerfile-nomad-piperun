# https://docs.docker.com/engine/reference/builder/
FROM ubuntu:focal

# Build-arguments (not persisted to final image)
# Branches: main (releases) / test (includes rc/beta versions)
ARG HASHICORP_REPO="https://apt.releases.hashicorp.com"
ARG HASHICORP_REPO_BRANCH="main"
ARG NOMAD_VERSION="0.12.8"
ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="true"

# Download dependencies & add apt-repo
RUN set -e \
    && apt-get update \
    && apt-get -qqy install apt-utils \
    && apt-get -qqy install curl gnupg lsb-release\
    && curl -fsSL ${HASHICORP_REPO}/gpg | apt-key add - \
    && printf "deb [arch=amd64] ${HASHICORP_REPO} $(lsb_release -cs) ${HASHICORP_REPO_BRANCH}\n"      >> /etc/apt/sources.list.d/hashicorp.list \
    && printf "#deb-src [arch=amd64] ${HASHICORP_REPO} $(lsb_release -cs) ${HASHICORP_REPO_BRANCH}\n" >> /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get clean all

# Install Nomad
RUN set -e \
    && apt-get -qqy install nomad=${NOMAD_VERSION} \
    && apt-get clean all

USER nomad

ENTRYPOINT ["/usr/bin/nomad"]
CMD ["version"]
