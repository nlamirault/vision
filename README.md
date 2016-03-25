# Vision

[![License Apache 2][badge-license]](LICENSE)
[![GitHub version](https://badge.fury.io/gh/nlamirault%2Fvision.svg)](https://badge.fury.io/gh/nlamirault%2Fvision)

## Description

[Vision][] is a stack for monitoring and logging. It provides :

* [Elasticsearch][] web interface : `http://xxx:9200`
* [Kibana][] web interface : `http://xxx:9393`
* [Grafana][] web interface : `http://xxx:9999/`
* [InfluxDB][] web interface : `http://xxx:8083`
* [Heka][] dashboard : `http://xxx:4352`

## Installation

* Download and install a release :

        $ curl https://github.com/nlamirault/vision/releases/download/x.y.z/vision-x.y.z-linux.tar.gz
        $ tar zxvf vision-x.y.z
        $ cd vision-x.y.z
        $ ./init.sh

* Start services using [Docker Compose][]:

        $ docker-compose up -d

* Or using [SystemD][]:

        $ cp -r vision-*.service /lib/systemd/system/
        $ systemctl start vision-influxdb.service \
            vision-cadvisor.service \
            vision-elasticsearch.service  \
            vision-grafana.service \
            vision-kibana.service

* Creates the database for cadvisor (go to the InfluxDB UI):

        CREATE DATABASE cadvisor

or

        $ curl -G 'http://localhost:8086/query' --data-urlencode "q=CREATE DATABASE telegraf"

## Usage

### Monitoring servers : Elasticsearch/Kibana/Beats

* Install [Topbeat][] and [Packetbeat][]

* Requires [Elasticsearch][] and [Kibana][] services

* Loading the templates into Elasticsearch

        $ curl -XPUT 'http://localhost:9200/_template/packetbeat' \
            -d@beats/topbeat.template.json

        $ curl -XPUT 'http://localhost:9200/_template/packetbeat' \
            -d@beats/packetbeat.template.json

* Running *topbeat* metrics :

        $ topbeat -c beats/topbeat.yml

* Running *packetbeat* metrics :

        $ packetbeat -c beats/packetbeat.yml

* Testing the installation:

        $ curl -XGET 'http://localhost:9200/topbeat-*/_search?pretty'
        $ curl -XGET 'http://localhost:9200/packetbeat-*/_search?pretty'

* Loading Kibana dashboards:

        $ curl -L -O http://download.elastic.co/beats/dashboards/beats-dashboards-1.1.1.zip
        $ unzip beats-dashboards-1.1.1.zip
        $ cd beats-dashboards-1.1.1/
        $ ./load.sh

* Then open the Kibana website (`http://localhost:9393`), then select Topbeat index,
and open Topbeat dashboard. Do same with Packetbeat index and dashboard.


### Monitoring servers : Telegraf/InfluxDB/Grafana

* Install [Telegraf][]

* Requires [InfluxDB][] and [Grafana][] services

* Creates the database (go to the InfluxDB UI):

        CREATE DATABASE telegraf

or

        $ curl -G 'http://localhost:8086/query' --data-urlencode "q=CREATE DATABASE telegraf"

* Running *telegraf* metrics :

        $ telegraf -config telegraf/telegraf.conf

* Then open the Grafana dashboard (`http://localhost:9191`), add a data sources (InfluxDB 0.9.x) and import the *Vision Telegraf* dashboard from (`grafana/grafana-telegraf.json`)

* You could explore metrics into the InfluxDB UI on `http://localhost:8083` with the query :

        SHOW MEASUREMENTS


### Monitoring servers : Prometheus/Grafana

* Install [Prometheus][] and [Prometheus node exporter][]

* Launch services :

        $ ./prometheus -config.file=prometheus/vision.yml
        $ ./node_exporter

* Check Prometheus installation on : `http://localhost:9090` and
  `http://localhost:9090/consoles/node.html`

* hen open the Grafana dashboard (`http://localhost:9191`) and import the
  *Vision Prometheus* dashboard from (`grafana/grafana-prometheus.json`)


### Log analysis (Elasticsearch/Filebeat/Kibana)

* Install [Filebeat][]

* Launch [Elasticsearch][] and [Kibana][] services

* Loading the Index Template into Elasticsearch

        $ curl -XPUT 'http://localhost:9200/_template/packetbeat' \
            -d@beats/filebeat.template.json

* Running *filebeat* metrics :

        $ filebeat -c beats/filebeat.yml


### SystemD

You could use services files to launch *Vision* monitoring tools using *SystemD*.

    $ sudo cp systemd/*.service /lib/systemd/system/
    $ sudo systemctl enable vision-telegraf
    $ sudo systemctl enable vision-topbeat
    $ sudo systemctl enable vision-packetbeat
    $ sudo systemctl start vision-packetbeat.service vision-telegraf.service vision-topbeat.service


## Development

* Creates a virtual machine called *vision-dev* for the development environment :

        $ ./docker-machine create -d virtualbox vision-dev
        $ eval "$(./docker-machine env vision-dev)"

* Check *vision* machine runnning :

        $ ./docker-machine ls

* Launch *vision* :

        $ ./docker-compose up

* Open your browser and navigate to the IP address associated with the
*vision* virtual machine :

        $ ./docker-machine ip

* To see which environment variables are available to the **web** service,
run:

        $ ./docker-compose run web env


## Deployment

With our app running locally, we can now push this exact same environment
to a cloud hosting provider with Docker Machine

Set your credentials in your environment :

    $ source XXXXXXX.sh

Deploy a new instance :

    $ docker-machine -D create -d digitalocean \
        --digitalocean-access-token $DIGITALOCEAN_TOKEN \
        vision-prod

Now we have two Machines running, one locally and one on Digital Ocean:

    $ docker-machine ls
    NAME            ACTIVE     DRIVER         STATE     URL
    vision-dev      *          virtualbox     Running   tcp://w.x.y.z:2376
    vision-prod                digitalocean   Running   tcp://a.b.c.d:2376

Set *vision-prod* as the active machine and load the Docker environment :

    $ ./docker-machine active vision-prod
    $ eval "$(./docker-machine env vision-prod)"

Finally, let's build the application in the Cloud :

    $ ./docker-compose build
    $ ./docker-compose up -d



## Support

Feel free to ask question or make suggestions in our [Issue Tracker][].


## License

See [LICENSE](LICENSE) for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available.


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>



[Vision]: https://github.com/nlamirault/vision

[badge-license]: https://img.shields.io/badge/license-Apache2-green.svg?style=flat

[Docker]: https://www.docker.io
[Docker documentation]: http://docs.docker.io
[Docker Machine]:https://github.com/docker/machine
[Docker Compose]: https://github.com/docker/compose

[SystemD]: https://freedesktop.org/wiki/Software/systemd/

[Elasticsearch]: http://www.elasticsearch.org
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[Topbeat]: https://www.elastic.co/downloads/beats/topbeat
[Filebeat]: https://www.elastic.co/downloads/beats/filebeat
[Packetbeat]: https://www.elastic.co/downloads/beats/packetbeat

[Grafana]: http://grafana.org/

[InfluxDB]: http://influxdb.com
[Telegraf]: https://github.com/influxdb/telegraf

[Heka]: http://hekad.readthedocs.org/en/latest/

[Prometheus]: https://github.com/prometheus/prometheus
[Prometheus node exporter]: https://github.com/prometheus/node_exporter


[Virtualbox]: https://www.virtualbox.org
[Vagrant]: http://downloads.vagrantup.com
