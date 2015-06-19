# VERSION 1.4
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/influxdb

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

ENV INFLUXDB_VERSION 0.8.8

RUN apt-get update && \
    apt-get install -y wget curl && \
    apt-get clean

RUN mkdir -p /src/influxdb && \
    wget http://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb

ADD ./config.toml /src/influxdb/config.toml
ADD ./influxdb.sh /src/influxdb/influxdb.sh

EXPOSE 8083
EXPOSE 8086
EXPOSE 8090
EXPOSE 8099

VOLUME ["/var/lib/influxdb"]

CMD ["/src/influxdb/influxdb.sh"]
