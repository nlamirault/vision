# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/grafana

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

ENV GRAFANA_VERSION 1.9.0

RUN apt-get update -q && \
    apt-get install -y wget nginx-light supervisor && \
    apt-get clean

RUN mkdir -p /src/grafana && cd /src/grafana && \
    wget http://grafanarel.s3.amazonaws.com/grafana-$GRAFANA_VERSION.tar.gz && \
    tar xzvf grafana-$GRAFANA_VERSION.tar.gz --strip-components=1 && \
    rm grafana-$GRAFANA_VERSION.tar.gz

ADD ./influxdb_config.js /src/grafana/config.js
ADD ./vision.json /src/grafana/app/dashboards/default.json

# Nginx
ADD ./nginx.conf /etc/nginx/nginx.conf

ADD ./supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/var/log/supervisor"]
VOLUME ["/var/log/nginx"]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
