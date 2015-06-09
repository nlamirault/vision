#!/usr/bin/env bash

echo "[vision] Waiting for Elasticsearch"
while true; do
    nc -q 1 elasticsearch 9200 >/dev/null && break
done
echo "[vision] Starting Kibana"
/src/kibana/bin/kibana
