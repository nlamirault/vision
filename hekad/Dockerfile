# VERSION 1.1
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/hekad

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN apt-get update && \
    apt-get -y install wget

ENV HEKAD_VERSION 0.8.1

RUN mkdir /etc/hekad && \
    mkdir /var/cache/hekad

RUN wget https://github.com/mozilla-services/heka/releases/download/v${HEKAD_VERSION}/heka_${HEKAD_VERSION}_amd64.deb &&\
    dpkg -i heka_${HEKAD_VERSION}_amd64.deb &&\
    rm heka_${HEKAD_VERSION}_amd64.deb
ADD ./hekad.toml /etc/hekad/hekad.toml
ADD ./run.sh /usr/bin/visionhekad.sh

EXPOSE 4352

# ENTRYPOINT ["/usr/bin/hekad"]
# CMD ["-config=/etc/hekad/hekad.toml"]
CMD ["/usr/bin/hekad", "-config", "=", "/etc/hekad.hekad.toml"]
#CMD ["/usr/bin/visionhekad.sh"]
