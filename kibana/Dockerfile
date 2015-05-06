# VERSION 1.3
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/influxdb

FROM dockerfile/java:oracle-java7
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV KIBANA_VERSION 4.0.2-linux-x64

RUN apt-get -y update && \
    apt-get install -y ca-certificates wget \
    && apt-get clean

RUN mkdir -p /src/kibana && \
    cd /src/kibana && \
    wget https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.tar.gz && \
    tar xzf kibana-$KIBANA_VERSION.tar.gz --strip-components=1 && \
    rm kibana-$KIBANA_VERSION.tar.gz

ADD ./kibana.yml /src/kibana/config/kibana.yml
ADD ./kibana.sh /src/kibana.sh

EXPOSE 5601

CMD ["/src/kibana.sh"]
