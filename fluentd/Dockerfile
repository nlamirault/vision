# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/influxdb

FROM ubuntu:14.04
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

ENV FLUENTD_VERSION 0.12.0

RUN apt-get -q update && \
    apt-get install -y curl libcurl4-openssl-dev make sudo ruby-dev supervisor
# RUN curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh
# ENV LD_PRELOAD /usr/lib/fluent/jemalloc/lib/libjemalloc.so
# RUN ulimit -n 65536

# TODO: Add gem install xxxx --no-ri --no-rdoc

RUN gem install fluentd #:$FLUENTD_VERSION

RUN gem install fluent-plugin-elasticsearch --no-ri --no-rdoc && \
    gem install fluent-plugin-record-reformer --no-ri --no-rdoc && \
    gem install fluent-plugin-docker-metrics --no-ri --no-rdoc && \
    gem install fluentd-ui --no-ri --no-rdoc

ADD ./supervisord.conf /etc/supervisor/supervisord.conf
ADD ./fluent.conf /etc/fluent/

VOLUME ["/var/log/supervisor"]

EXPOSE 24224
EXPOSE 9292

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
