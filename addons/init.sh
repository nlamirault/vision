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

VISION_DIR=/opt/vision

sudo mkdir -p $VISION_DIR/elasticsearch/{lib,log}
sudo mkdir -p $VISION_DIR/influxdb/{db,log,lib,wal}
sudo mkdir -p $VISION_DIR/grafana/{lib,log}
sudo mkdir -p $VISION_DIR/kibana/log
sudo chown -R $USER.users $VISION_DIR
