# VERSION 1.1
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/influxdb

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN apt-get update && apt-get install -y wget supervisor

ENV INFLUXDB_VERSION 0.8.7

RUN mkdir -p /src/influxdb && \
    wget http://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb

ADD ./config.toml /src/influxdb/config.toml

ADD ./supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 8083
EXPOSE 8086
EXPOSE 8090
EXPOSE 8099

VOLUME ["/var/lib/influxdb"]
VOLUME ["/var/log/supervisor"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
