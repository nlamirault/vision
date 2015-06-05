# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/haproxy

FROM debian:jessie
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

ENV CONSUL_VERSION 0.5.2

RUN mkdir -p /etc/consul.d/
RUN apt-get update && \
    apt-get install -y ca-certificates curl unzip --no-install-recommends

RUN mkdir -p /src/consul && \
    cd /src/consul && \
    curl -O -J -L https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_amd64.zip && \
    unzip ${CONSUL_VERSION}_linux_amd64.zip && \
    chmod +x consul && \
    rm ${CONSUL_VERSION}_linux_amd64.zip

RUN mkdir -p /src/consul/ui && \
    cd /src/consul/ui && \
    curl -O -J -L https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_web_ui.zip && \
    unzip ${CONSUL_VERSION}_web_ui.zip && \
    mv dist/* . && \
    rm -rf dist

VOLUME ["/var/lib/consul"]

EXPOSE 8400 8500 8600/udp

CMD [ "/src/consul/consul agent -server -data-dir=/var/lib/consul -client=0.0.0.0 -ui-dir /src/consul/ui/"]
