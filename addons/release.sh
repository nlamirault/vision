#!/bin/bash

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

set -e

APP="vision"

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"

image_version() {
    IMAGE=$1
    grep ' VERSION' $IMAGE/Dockerfile|awk -F" " '{ print $3 }'
}

create_archive_directory() {
    OS=$1
    mkdir -p $APP-$VERSION-$OS
    cp ./docker-compose-$OS $APP-$VERSION-$OS/docker-compose
    cp ./docker-machine-linux $APP-$VERSION-$OS/docker-machine
}

release() {
    OS=$1
    VERSION=$2
    if [ "linux" == "$OS" ] || [ "darwin" == "$OS" ]; then
        create_archive_directory $OS
    else
        echo -e "$ERROR_COLOR[$APP] Invalid OS $OS. Must be: darwin or linux."
        exit 1
    fi
    echo -e "$OK_COLOR[$APP] Make archive for $OS $VERSION $NO_COLOR"
    COMPOSE_FILE=$APP-$VERSION-$OS/docker-compose.yml
    cp addons/docker-compose.yml $COMPOSE_FILE
    cp addons/init.sh $APP-$VERSION-$OS/
    ES_VERSION=$(image_version "elasticsearch")
    KIBANA_VERSION=$(image_version "kibana")
    GRAFANA_VERSION=$(image_version "grafana")
    INFLUXDB_VERSION=$(image_version "influxdb")
    FLUENTD_VERSION=$(image_version "fluentd")
    CADVISOR_VERSION="0.14.0"
    sed -i "s/ES_VERSION/$ES_VERSION/g" $COMPOSE_FILE
    sed -i "s/KIBANA_VERSION/$KIBANA_VERSION/g" $COMPOSE_FILE
    sed -i "s/GRAFANA_VERSION/$GRAFANA_VERSION/g" $COMPOSE_FILE
    sed -i "s/INFLUXDB_VERSION/$INFLUXDB_VERSION/g" $COMPOSE_FILE
    sed -i "s/FLUENTD_VERSION/$FLUENTD_VERSION/g" $COMPOSE_FILE
    sed -i "s/CADVISOR_VERSION/$CADVISOR_VERSION/g" $COMPOSE_FILE
    tar cf - $APP-$VERSION-$OS | gzip > $APP-$VERSION-$OS.tar.gz
    rm -fr $APP-$VERSION-$OS
}

if [ $# -eq 2 ]
then
    release $1 $2
else
    echo "Error. Usage: $0 <linux|darwin> <version>"
fi
