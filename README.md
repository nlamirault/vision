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

## Local Installation

* Download and install a release :

        $ curl https://github.com/nlamirault/vision/releases/download/x.y.z/vision-x.y.z-linux.tar.gz
        $ tar zxvf vision-x.y.z
        $ cd vision-x.y.z

* Start it :

        $ ./init.sh
        $ docker-compose up -d

## Usage

### Monitoring servers : Elasticsearch/Kibana/Beats

* Install [Topbeat][]

* Launch [Elasticsearch][] and [Kibana][] services :

        $ docker-compose up -d elasticsearch kibana

* Loading the Index Template into Elasticsearch

        $ curl -XPUT 'http://localhost:9200/_template/packetbeat' \
            -d@beats/topbeat.template.json

* Running *topbeat* metrics :

        $ topbeat -c beats/topbeat.yml

* Testing the Topbeat installation:

        $ curl -XGET 'http://localhost:9200/topbeat-*/_search?pretty'

* Loading Kibana dashboards:

        $ curl -L -O http://download.elastic.co/beats/dashboards/beats-dashboards-1.0.0.tar.gz
        $ cd beats-dashboards-1.0.0
        $ ./load.sh

* Then open the Kibana website (`http://localhost:9393`), then select Topbeat index, and open Topbeat dashboard.


### Monitoring servers : Telegraf/InfluxDB/Grafana

* Install [Telegraf][]

* Launch [InfluxDB][] and [Grafana][] services :

        $ docker-compose up -d influxdb grafana

* Running *telegraf* metrics :

        $ telegraf -config telegraf/telegraf.conf

* Then open the Grafana dashboard (`http://localhost:9191`) and import the *Vision Telegraf* dashboard from (`grafana/grafana-telegraf.json`)

* You could explore metrics into the InfluxDB UI on `http://localhost:8083` with the query :

        SHOW MEASUREMENTS


### Log analysis (Elasticsearch/Filebeat/Kibana)

* Install [Filebeat][]

* Launch [Elasticsearch][] and [Kibana][] services :

        $ docker-compose up -d elasticsearch kibana

* Loading the Index Template into Elasticsearch

        $ curl -XPUT 'http://localhost:9200/_template/packetbeat' \
            -d@beats/filebeat.template.json

* Running *filebeat* metrics :

        $ filebeat -c beats/filebeat.yml


### Log analysis (Elasticsearch/Heka/Kibana)

* Install [Heka][]

* Launch [Elasticsearch][], [Heka][] and [Kibana][] services :

        $ docker-compose up -d elasticsearch grafana heka


## Development

### Simple

* Build the images :

        $ make build image=xxx

* Setup directories :

        $ make setup

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
[Docker Complete]: https://github.com/docker/compose

[Elasticsearch]: http://www.elasticsearch.org
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[Topbeat]: https://www.elastic.co/downloads/beats/topbeat
[Filebeat]: https://www.elastic.co/downloads/beats/filebeat

[Grafana]: http://grafana.org/

[InfluxDB]: http://influxdb.com
[Telegraf]: https://github.com/influxdb/telegraf

[Heka]: http://hekad.readthedocs.org/en/latest/

[Virtualbox]: https://www.virtualbox.org
[Vagrant]: http://downloads.vagrantup.com
