#!/bin/bash

# Copyright (C) 2014, 2016 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

APP="vision"

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"

release() {
    VERSION=$1
    DIR=${APP}-${VERSION}
    mkdir -p ${DIR}
    echo -e "$OK_COLOR[$APP] Make archive for $OS $VERSION $NO_COLOR"
    COMPOSE_FILE=${DIR}/docker-compose.yml
    cp docker-compose.yml ${COMPOSE_FILE}
    cp addons/init.sh ${DIR}/
    cp -r systemd/*.service ${DIR}/
    tar cf - ${DIR} | gzip > ${DIR}.tar.gz
    rm -fr ${DIR}
}

if [ $# -eq 1 ]
then
    release $1
else
    echo "Error. Usage: $0 <version>"
fi
