#!/bin/bash

# Copyright (C) 2014, 2016  Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

VISION_DIR=/opt/vision

sudo mkdir -p $VISION_DIR/elasticsearch/{lib,log}
sudo mkdir -p $VISION_DIR/influxdb/{db,log,lib,wal}
sudo mkdir -p $VISION_DIR/grafana/{lib,log}
sudo mkdir -p $VISION_DIR/kibana/log
# sudo chown -R $USER.users $VISION_DIR
