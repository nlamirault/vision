# VERSION 1.3
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/hekad

FROM debian:jessie
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN apt-get update && \
    apt-get -y install wget && \
    apt-get clean

ENV HEKAD_VERSION 0.9.2

RUN mkdir /etc/hekad && \
    mkdir /var/cache/hekad

RUN useradd -d / -M -U -c "hekad user" -s /usr/sbin/nologin heka && \
    mkdir /etc/hekad && \
    mkdir /var/cache/hekad && \
    chown heka:heka /var/cache/hekad && \
    wget https://github.com/mozilla-services/heka/releases/download/v${HEKAD_VERSION}/heka_${HEKAD_VERSION}_amd64.deb && \
    dpkg -i heka_${HEKAD_VERSION}_amd64.deb && \
    rm heka_${HEKAD_VERSION}_amd64.deb

ADD ./hekad.toml /etc/hekad/hekad.toml
# ADD ./run.sh /usr/bin/visionhekad.sh

USER heka

EXPOSE 4352

CMD ["/usr/bin/hekad", "-config", "=", "/etc/hekad.hekad.toml"]
