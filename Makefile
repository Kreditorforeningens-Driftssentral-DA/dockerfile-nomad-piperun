# Example makefile

export BUILD_TAG      ?= nomad:piperun
export CONTAINER_NAME ?= piperun
export NOMAD_ADDR     ?= http://172.17.0.1:4646

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

clean:
	@docker image rm ${BUILD_TAG}
.PHONY: clean
