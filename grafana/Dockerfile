# VERSION 1.2
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/grafana

# FROM ubuntu:14.04
FROM debian:jessie
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

ENV GRAFANA_VERSION 2.0.2

RUN apt-get update -q && \
    apt-get install -y wget nginx-light supervisor && \
    apt-get clean

RUN mkdir -p /src/grafana && \
    cd /src/grafana && \
    curl -O -J -L https://grafanarel.s3.amazonaws.com/builds/grafana-$GRAFANA_VERSION.linux-x64.tar.gz && \
    tar xzvf grafana-$GRAFANA_VERSION.linux-x64.tar.gz --strip-components=1 && \
    rm grafana-$GRAFANA_VERSION.linux-x64.tar.gz

# ADD ./grafana_config.js /src/grafana/config.js
# ADD ./vision.json /src/grafana/app/dashboards/default.json

VOLUME ["/var/lib/grafana"]
VOLUME ["/var/log/grafana"]

EXPOSE 3000

CMD ["/usr/sbin/grafana-server", "-config=/etc/grafana/grafana.ini"]
