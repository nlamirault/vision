# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/influxdb

FROM java:7
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

ENV KIBANA_VERSION 4.0.0-BETA2

RUN apt-get -y update && apt-get install -y wget supervisor && apt-get clean

RUN mkdir -p /src/kibana && \
    cd /src/kibana && \
    wget https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.tar.gz && \
    tar xzf kibana-$KIBANA_VERSION.tar.gz --strip-components=1 && \
    rm kibana-$KIBANA_VERSION.tar.gz

# ADD ./config.js /src/kibana/config.js
# ADD ./vision.json /src/kibana/app/dashboards/default.json
ADD ./kibana.yml /src/kibana/config/kibana.yml

# ADD ./nginx.conf /etc/nginx/nginx.conf

ADD ./supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/var/log/supervisor"]

EXPOSE 5601

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
