.PHONY: shell
.PHONY: clean
	
TOOLCHAIN_NAME=miyoomini-toolchain
WORKSPACE_DIR := $(shell pwd)/workspace
TOOL=
DOCKER := $(shell command -v docker 2> /dev/null)
PODMAN := $(shell command -v podman 2> /dev/null)

.check:
ifdef DOCKER
    TOOL=docker
else ifdef PODMAN
    TOOL=podman
else
    $(error "Docker or Podman must be installed!")
endif

.build: .check Dockerfile
	mkdir -p ./workspace
	$(TOOL) build -t $(TOOLCHAIN_NAME) .
	touch .build

shell: .check .build
	$(TOOL) run -it --rm -v "$(WORKSPACE_DIR)":/root/workspace $(TOOLCHAIN_NAME) /bin/bash

clean: .check
	$(TOOL) rmi $(TOOLCHAIN_NAME)
	rm -f .build
