# Copyright (C) 2014, 2015  Nicolas Lamirault <nicolas.lamirault@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

APP=vision
NAMESPACE=$(APP)

OS = darwin linux

VERSION=0.5.0

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

DOCKER = docker

DOCKER_MACHINE_URI=https://github.com/docker/machine/releases/download
DOCKER_MACHINE_VERSION=v0.2.0

DOCKER_COMPOSE_URI=https://github.com/docker/compose/releases/download
DOCKER_COMPOSE_VERSION=1.2.0

K8S_KUBECTL_URI=https://storage.googleapis.com/kubernetes-release/release
K8S_VERSION=v0.19.0

UNAME := $(shell uname)
ifeq ($(UNAME),$(filter $(UNAME),Linux Darwin))
ifeq ($(UNAME),$(filter $(UNAME),Darwin))
OS=darwin
else
OS=linux
endif
else
OS=windows
endif

ifneq ($(image),)
IMAGE_VERSION := $(shell grep ' VERSION' ${image}/Dockerfile|awk -F" " '{ print $$3 }')
endif

all: help

help:
	@echo -e "$(OK_COLOR)==== $(APP) [$(VERSION)] ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- init      : Download dependencies used by Vision"
	@echo -e "$(WARN_COLOR)- build     : Make the Docker image"
	@echo -e "$(WARN_COLOR)- publish   : Publish the image"
	@echo -e "$(WARN_COLOR)- release   : Make a new release"

machine-linux:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker machine Linux$(NO_COLOR)"
	@wget --quiet $(DOCKER_MACHINE_URI)/$(DOCKER_MACHINE_VERSION)/docker-machine_linux-amd64 -O docker-machine-linux
	@chmod +x ./docker-machine-linux

machine-darwin:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker machine OSX$(NO_COLOR)"
	@wget --quiet $(DOCKER_MACHINE_URI)/$(DOCKER_MACHINE_VERSION)/docker-machine_darwin-amd64 -O docker-machine-darwin
	@chmod +x ./docker-machine-darwin

# machine-windows:
# 	@echo -e "$(OK_COLOR)[$(APP)] Install Docker machine Windows$(NO_COLOR)"
# 	@wget --quiet $(DOCKER_MACHINE_URI)/$(DOCKER_MACHINE_VERSION)/docker-machine_windows-amd64.exe -O docker-machine-windows
# 	@chmod +x ./docker-machine-windows

compose-linux:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker compose Linux$(NO_COLOR)"
	@wget --quiet $(DOCKER_COMPOSE_URI)/$(DOCKER_COMPOSE_VERSION)/docker-compose-Linux-x86_64 -O docker-compose-linux
	@chmod +x ./docker-compose-linux

compose-darwin:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker compose OSX$(NO_COLOR)"
	@wget --quiet $(DOCKER_COMPOSE_URI)/$(DOCKER_COMPOSE_VERSION)/docker-compose-Darwin-x86_64 -O docker-compose-darwin
	@chmod +x ./docker-compose-darwin

.PHONY: init
init: machine-$(OS) compose-$(OS)
	@mv ./docker-compose-$(OS) ./docker-compose
	@mv ./docker-machine-$(OS) ./docker-machine

.PHONY: kubectl-linux
kubectl-linux:
	@echo -e "$(OK_COLOR)[$(APP)] Install Kubectl Linux$(NO_COLOR)"
	@wget --quiet $(K8S_KUBECTL_URI)/$(K8S_VERSION)/bin/linux/amd64/kubectl -O kubectl-linux
	@chmod +x ./kubectl-linux

.PHONY: kubectl-darwin
kubectl-darwin:
	@echo -e "$(OK_COLOR)[$(APP)] Install Kubectl OSX$(NO_COLOR)"
	@wget --quiet $(K8S_KUBECTL_URI)/$(K8S_VERSION)/bin/darwin/amd64/kubectl -O kubectl-darwin
	@chmod +x ./kubectl-darwin

.PHONY: k8s
k8s: kubectl-$(OS)
	@mv ./kubectl-$(OS) ./kubectl

.PHONY: build
build:
	@echo -e "$(OK_COLOR)[$(APP)] Build $(NAMESPACE)/$(image):$(IMAGE_VERSION)$(NO_COLOR)"
	@$(DOCKER) build -t $(NAMESPACE)/$(image):$(IMAGE_VERSION) $(image)

.PHONY: login
login:
	@$(DOCKER) login https://index.docker.io/v1/

.PHONY: publish
publish:
	@echo -e "$(OK_COLOR)[$(APP)] Publish $(NAMESPACE)/$(image):$(IMAGE_VERSION)$(NO_COLOR)"
	@$(DOCKER) push $(NAMESPACE)/$(image):$(IMAGE_VERSION)

.PHONY: binaries
binaries: machine-linux compose-linux machine-darwin compose-darwin
	@echo -e "$(OK_COLOR)[$(APP)] Make binaries $(NO_COLOR)"
	@addons/release.sh linux $(VERSION)
	@addons/release.sh darwin $(VERSION)
	@rm -f ./docker-compose-* ./docker-machine-*

.PHONY: release
release: binaries
	@echo -e "$(OK_COLOR)[$(APP)] New release $(VERSION) $(NO_COLOR)"
	@addons/github.sh $(VERSION)

clean:
	@echo -e "$(OK_COLOR)[$(APP)] Nettoyage de l'environnement$(NO_COLOR)"
	@rm -fr *.tar.gz $(APP)-* ./docker-compose ./docker-machine
	@rm -f ./docker-compose-* ./docker-machine-*
