#!/bin/bash

cat << EOF > /etc/td-agent/td-agent.conf
<source>
  type http
  port 8888
</source>

<match aftership.*>
  type elasticsearch
  host $ES_HOST
  port $ES_PORT
  index_name via_fluentd
  type_name via_fluentd
  logstash_format true
  utc_index true
  include_tag_key false
</match>

EOF

fluentd-ui start
