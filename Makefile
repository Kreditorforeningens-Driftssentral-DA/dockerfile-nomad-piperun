# Example makefile

export BUILD_TAG      ?= nomad:piperun
export NOMAD_ADDR     ?= http://172.17.0.1:4646
export CONTAINER_NAME ?= piperun

export REPO_IMAGE_NAME    := kdsda/nomad-piperun
export REPO_IMAGE_VERSION := v0.12.8

all: build version
.PHONY: all

build:
	@docker build -t ${BUILD_TAG} -f Dockerfile .
.PHONY: build

rebuild:
	@docker build --no-cache -t ${BUILD_TAG} -f Dockerfile .
.PHONY: rebuild

version: # ${@} equals name of current make-command (version)
	@docker run --rm -it -e ${NOMAD_ADDR} \
		--name ${CONTAINER_NAME} \
		${BUILD_TAG} ${@}
.PHONY: version

ext: # ${@} equals name of current make-command (version)
	@docker run --rm -it -e ${NOMAD_ADDR} \
		${REPO_IMAGE_NAME}:${REPO_IMAGE_VERSION} \
		version
.PHONY: ext


clean:
	@docker image rm ${BUILD_TAG}
.PHONY: clean
