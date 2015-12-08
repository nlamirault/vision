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

VERSION=1.0.0

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

DOCKER = docker

DOCKER_MACHINE_URI=https://github.com/docker/machine/releases/download
DOCKER_MACHINE_VERSION=v0.5.2

DOCKER_COMPOSE_URI=https://github.com/docker/compose/releases/download
DOCKER_COMPOSE_VERSION=1.5.2

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
	@echo -e "$(WARN_COLOR)- init              : Download dependencies used by Vision"
	@echo -e "$(WARN_COLOR)- build image=xx    : Make the Docker image"
	@echo -e "$(WARN_COLOR)- publish image=xx  : Publish the image"
	@echo -e "$(WARN_COLOR)- release           : Make a new release"

machine-linux:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker machine Linux$(NO_COLOR)"
	@curl -L --silent $(DOCKER_MACHINE_URI)/$(DOCKER_MACHINE_VERSION)/docker-machine_linux-amd64.zip -o docker-machine_linux.zip

machine-darwin:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker machine OSX$(NO_COLOR)"
	@curl -L --silent $(DOCKER_MACHINE_URI)/$(DOCKER_MACHINE_VERSION)/docker-machine_darwin-amd64.zip -o docker-machine_darwin.zip

machine-windows:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker machine Windows$(NO_COLOR)"
	@curl -L --silent $(DOCKER_MACHINE_URI)/$(DOCKER_MACHINE_VERSION)/docker-machine_windows-amd64.zip -o docker-machine_windows.zip

compose-linux:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker compose Linux$(NO_COLOR)"
	@curl -L --silent $(DOCKER_COMPOSE_URI)/$(DOCKER_COMPOSE_VERSION)/docker-compose-Linux-x86_64 -o docker-compose-linux
	@chmod +x docker-compose-linux

compose-darwin:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker compose OSX$(NO_COLOR)"
	@curl -L --silent $(DOCKER_COMPOSE_URI)/$(DOCKER_COMPOSE_VERSION)/docker-compose-Darwin-x86_64 -o docker-compose-darwin
	@chmod +x docker-compose-darwin

compose-windows:
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker compose OSX$(NO_COLOR)"
	@curl -L --silent $(DOCKER_COMPOSE_URI)/$(DOCKER_COMPOSE_VERSION)/docker-compose-Windows-x86_64.exe -o docker-compose-windows
	@chmod +x docker-compose-windows

.PHONY: init
init: machine-$(OS) compose-$(OS)

archives: machine-linux compose-linux machine-darwin compose-darwin
	@echo -e "$(OK_COLOR)[$(APP)] Make binaries $(NO_COLOR)"
	@addons/release.sh linux $(VERSION)
	@addons/release.sh darwin $(VERSION)
	@rm -f ./docker-compose-* ./docker-machine-*.zip

.PHONY: release
release: binaries
	@echo -e "$(OK_COLOR)[$(APP)] New release $(VERSION) $(NO_COLOR)"
	@addons/github.sh $(VERSION)

clean:
	@echo -e "$(OK_COLOR)[$(APP)] Nettoyage de l'environnement$(NO_COLOR)"
	@rm -fr *.tar.gz $(APP)-*
	@rm -f ./docker-compose-* ./docker-machine_*
