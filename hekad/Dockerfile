# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/hekad

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN apt-get update && \
        apt-get -y install wget && \

ENV HEKAD_VERSION 0.8.0

RUN mkdir /etc/hekad && \
    mkdir /var/cache/hekad

RUN wget https://github.com/mozilla-services/heka/releases/download/v${HEKAD_VERSION}/heka_${HEKAD_VERSION}_amd64.deb &&\
    dpkg -i heka_${HEKAD_VERSION}_amd64.deb &&\
    rm /tmp/heka_amd64.deb

ENTRYPOINT ["/usr/bin/hekad"]

CMD ["-config=/etc/hekad/hekad.toml"]
