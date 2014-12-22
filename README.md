# Vision

[![License GPL 3][badge-license]][COPYING]

## Description

[Vision][] is a system monitoring and log collector.
It is based on :

* [Docker][] (>= 1.3)
* [Elasticsearch][] (v1.4.0) web interface : `http://xxx:9200`
* [Grafana][] (v1.8.0) web interface : `http://xxx:9090/`
* [Kibana][] (v4.0.0) web interface : `http://xxx:5601`
* [InfluxDB][] (v0.8.0) web interface : `http://xxx:8083`

Some [Elasticsearch][] plugins are available:
* [ElasticSearchHead][]: `http://xxx:9200/_plugin/head/`
* [ElasticHQ][]: `http://xxx:9200/_plugin/HQ/`
* [Kopf][]: `http://xxx:9200/_plugin/kopf/`


## Deployment

### Local

* Install it:

        $ make init
        $ ./fig up

* Creates the [InfluxDB][] database:

        $ curl -X POST 'http://localhost:8086/db?u=root&p=root' \
            -d '{"name": "vision"}'

* Verify input datas from the InfluxDB UI (on 8083), using this query, after choosing `vision`
  database:

        select * from /.*/ limit 100


## Usage

### Monitoring

* You could use [sysinfo_influxdb][] to send metrics :

        $ sysinfo_influxdb -host 127.0.0.1:8086 -P vision -d vision -v=text -D


### Logging

* You could use [Heka][] and this configuration file [addons/hekad.toml][]
  to watch `local7.log` and send them to Elasticsearch:

        $ sudo bin/hekad -config=addons/hekad.toml

* Into [Kibana][], set the default index and visualize logs:

        logfile-*


## Development

* Build the images :

        $ make build image=xxx

* Setup directories :

        $ make setup


## Support

Feel free to ask question or make suggestions in our [Issue Tracker][].


## License

Vision is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

Vision is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

See [COPYING][] for the complete license.


## Changelog

A changelog is available [here](ChangeLog.md).


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>



[Vision]: https://github.com/nlamirault/vision
[COPYING]: https://github.com/nlamirault/vision/blob/master/COPYING
[Issue tracker]: https://github.com/nlamirault/vision/issues
[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat

[Docker]: https://www.docker.io
[Docker documentation]: http://docs.docker.io

[Elasticsearch]: http://www.elasticsearch.org
[Grafana]: http://grafana.org/
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[ElasticSearchHead]: http://mobz.github.io/elasticsearch-head
[ElasticHQ]: http://www.elastichq.org
[Kopf]: https://github.com/lmenezes/elasticsearch-kopf
[Fluentd]: http://fluentd.org/
[Heka]: http://hekad.readthedocs.org/en/latest/
[Supervisor]: http://supervisord.org
[sysinfo_influxdb]: https://github.com/novaquark/sysinfo_influxdb
[InfluxDB]: http://influxdb.com

[Virtualbox]: https://www.virtualbox.org
[Vagrant]: http://downloads.vagrantup.com
[SystemdD]: http://freedesktop.org/wiki/Software/systemd
