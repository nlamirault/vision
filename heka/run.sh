#!/bin/bash

ES_HOST=${ES_HOST:-}
ES_PORT=${ES_PORT:-}

sed -e "s/ES_HOST/${ES_PORT}/g" \
    -e "s/ES_PORT/${ES_PORT}/g" \
    -i /etc/hekad/hekad.toml

/usr/bin/hekad -config=/etc/hekad/hekad.toml
