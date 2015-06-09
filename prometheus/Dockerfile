# VERSION 1.0
# AUTHOR:         Nicolas Lamirault <nicolas.lamirault@gmail.com>
# DESCRIPTION:    vision/prometheus

FROM prom/prometheus
MAINTAINER Nicolas Lamirault <nicolas.lamirault@gmail.com>

RUN mkdir /config

COPY config/prometheus.conf /config/prometheus.conf

ENTRYPOINT [ "/go/src/github.com/prometheus/prometheus/prometheus" ]
CMD        [ "-logtostderr", "-config.file=/config/prometheus.conf", \
             "-web.console.libraries=/go/src/github.com/prometheus/prometheus/console_libraries", \
             "-web.console.templates=/go/src/github.com/prometheus/prometheus/consoles" ]
