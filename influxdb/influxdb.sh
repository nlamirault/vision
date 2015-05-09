#!/usr/bin/env bash

echo "[vision] Starting InfluxDB"
/usr/bin/influxdb -config=/src/influxdb/config.toml
