# Vision

[![License GPL 3][badge-license]][COPYING]
![Version][badge-release]

## Description

[Vision][] is a [Docker][] stack.

### Core

Services discovering of containers is provided by :

* [HAProxy][]: a TCP/HTTP load balancer (Stats: `http://xxx:8936`)
* [Consul][]: service discovering (`http://xxx:8500`)
* [Consul-template][]: populate values from Consul on your filesystem.
* [Registrator][]: automatically register/deregister Docker containers into Consul.

Monitoring of containers is provided by :

* [cAdvisor][] is used (`http://xxx:9999`) to monitoring containers.
* [Prometheus][] the service monitoring system and time series database (`http://xxx:9090`)

### Logging service

Log collector service is provided using :

* [Elasticsearch][] web interface : `http://xxx:9200`
* [Kibana][] web interface : `http://xxx:5601`

Some [Elasticsearch][] plugins are available:
* [ElasticSearchHead][]: `http://xxx:9200/_plugin/head/`
* [ElasticHQ][]: `http://xxx:9200/_plugin/HQ/`
* [Kopf][]: `http://xxx:9200/_plugin/kopf/`

### Monitoring service

Monitoring service is provided using :

* [Grafana][] web interface : `http://xxx:9191/`
* [InfluxDB][] web interface : `http://xxx:8083`

## Deployment

### Local

* Download and install a release :

        $ curl https://github.com/nlamirault/vision/releases/download/x.y.z/vision-x.y.z-linux.tar.gz
        $ tar zxvf vision-x.y.z
        $ cd vision-x.y.z

* Start it :

        $ ./init.sh
        $ docker-compose up

* Creates the [InfluxDB][] database:

        $ curl -X POST 'http://localhost:8086/db?u=root&p=root' \
            -d '{"name": "cadvisor"}'

* Verify input datas from the InfluxDB UI (on 8083), using this query, after choosing `vision`
  database:

        select * from /.*/ limit 100

* Open your browser to the Grafana dashboard (on 9191). Log into, then click on
`Data Sources` > `Add New`. Enter this content :

        Data Source Settings

        Name: influxdb
        Type: InfluxDB 0.8.x
        Ddefault : YES

        Http settings
        Url: http://influxdb:8086
        Access: proxy
        Basic Auth: Enabled
        User: admin
        Password: admin

        InfluxDB Details
        Database: cadvisor
        User: root
        Password: root


### Kubernetes

Launch using [Kubernetes][]:

    $ docker-compose -f k8s.yml up

### Mesos

Launch using [Mesos][]:

    $ docker-compose -f mesos.yml up



## Usage

### Monitoring

* You could use [sysinfo_influxdb][] to send metrics :

        $ sysinfo_influxdb -host 127.0.0.1:8086 -P vision -d vision -v=text -D


### Logging

* You could use [Heka][] and this configuration file [addons/hekad.toml][]
  to watch `local7.log` and send them to Elasticsearch:

        $ curl http://xx.xx.xx.xx:9200/hekad -X POST

* Using binary :

        $ sudo bin/hekad -config=addons/hekad.toml

* Into [Kibana][], set the default index and visualize logs:

        logfile-*


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


### Kubernetes

*  Run [Kubernetes][] on a single host :

        $ docker-compose -f k8s.yml up -d


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
    $ ./docker-compose up -d -f production.yml









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

A [ChangeLog.md][] is available.


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>



[Vision]: https://github.com/nlamirault/vision
[COPYING]: https://github.com/nlamirault/vision/blob/master/COPYING
[Issue tracker]: https://github.com/nlamirault/vision/issues
[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg
[badge-release]: https://img.shields.io/github/release/nlamirault/vision.svg

[Docker]: https://www.docker.io
[Docker documentation]: http://docs.docker.io
[Docker Machine]:https://github.com/docker/machine
[Docker Complete]: https://github.com/docker/compose

[Kubernetes]: http://kubernetes.io
[Mesos]: http://mesos.apache.org/

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
[cAdvisor]: https://github.com/google/cadvisor
[HAProxy]: http://www.haproxy.org/
[Consul]: http://www.consul.io
[Consul-template]: https://github.com/hashicorp/consul-template
[Registrator]: https://github.com/gliderlabs/registrator
[Prometheus]: See: http://prometheus.io

[Virtualbox]: https://www.virtualbox.org
[Vagrant]: http://downloads.vagrantup.com
[SystemdD]: http://freedesktop.org/wiki/Software/systemd
