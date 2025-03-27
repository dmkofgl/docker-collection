## Healthcheck

The HEALTHCHECK instruction is used in a Dockerfile to tell Docker how to test a container to check if it is still working. This instruction
can be defined for any container, and Docker will periodically run this command in the container.
The HEALTHCHECK instruction has two forms:

``HEALTHCHECK [OPTIONS] CMD command`` (check container health by running a command inside the container)
``HEALTHCHECK NONE`` (disable any healthcheck inherited from the base image)
Whenever a health check passes, it becomes healthy (whatever state it was previously in). After a certain number of consecutive failures, it
becomes unhealthy.

The options that can appear before CMD are:

- ``--interval=DURATION (default: 30s)``
- ``--timeout=DURATION (default: 30s)``
- ``--start-period=DURATION (default: 0s)``
- ``--start-interval=DURATION (default: 5s)``
- ``--retries=N (default: 3)``

The health check will first run `interval` seconds after the container is started, and then again `interval` seconds after each previous
check
completes.

If a single run of the check takes longer than `timeout` seconds then the check is considered to have failed.

It takes `retries` consecutive failures of the health check for the container to be considered unhealthy.

`start period` provides initialization time for containers that need time to bootstrap. Probe failure during that period will not be counted
towards the maximum number of retries. However, if a health check succeeds during the start period, the container is considered started and
all consecutive failures will be counted towards the maximum number of retries.

`start interval` is the time between health checks during the start period. This option requires Docker Engine version 25.0 or later.

> There can only be one HEALTHCHECK instruction in a Dockerfile. If you list more than one then only the last HEALTHCHECK will take effect.

The command after the CMD keyword can be either a shell command (e.g. HEALTHCHECK CMD /bin/check-running) or an exec array (as with other
Dockerfile commands; see e.g. ENTRYPOINT for details).

The command's exit status indicates the health status of the container. The possible values are:

0: success - the container is healthy and ready for use
1: unhealthy - the container isn't working correctly
2: reserved - don't use this exit code

For example, to check every five minutes or so that a web-server is able to serve the site's main page within three seconds:

``HEALTHCHECK --interval=5m --timeout=3s \
CMD curl -f http://localhost/ || exit 1``

To help debug failing probes, any output text (UTF-8 encoded) that the command writes on stdout or stderr will be stored in the health
status and can be queried with docker inspect. Such output should be kept short (only the first 4096 bytes are stored currently).

## Logging

The `` docker logs`` command shows information logged by a running container. The ``docker service logs`` command shows information logged
by all
containers participating in a service. The information that's logged and the format of the log depends almost entirely on the container's
endpoint command.

Unix and Linux commands typically open three I/O streams when they run, called `STDIN`, `STDOUT`, and `STDERR`. `STDIN` is the command's
input
stream, which may include input from the keyboard or input from another command. `STDOUT` is usually a command's normal output, and `STDERR`
is
typically used to output error messages. By default, docker logs shows the command's `STDOUT` and `STDERR`.

In some cases, docker logs may not show useful information unless you take additional steps.

- If you use a logging driver which sends logs to a file, an external host, a database, or another logging back-end, and have "dual logging"
  disabled, docker logs may not show useful information.
- If your image runs a non-interactive process such as a web server or a database, that application may send its output to log files instead
  of STDOUT and STDERR.

### Drivers (json-file, fluentd, etc.)

Docker includes multiple logging mechanisms to help you get information from running containers and services. These mechanisms are called
logging drivers. Each Docker daemon has a default logging driver, which each container uses unless you configure it to use a different
logging driver, or log driver for short.

As a default, Docker uses the json-file logging driver, which caches container logs as JSON internally. In addition to using the logging
drivers included with Docker, you can also implement and use logging driver plugins.

If you don't specify a logging driver, the default is json-file. To find the current default logging driver for the Docker daemon, run
docker info and search for Logging Driver. You can use the following command on Linux, macOS, or PowerShell on Windows:

``docker info --format '{{.LoggingDriver}}'``

When you start a container, you can configure it to use a different logging driver than the Docker daemon's default, using the --log-driver
flag. If the logging driver has configurable options, you can set them using one or more instances of the --log-opt <NAME>=<VALUE> flag.
Even if the container uses the default logging driver, it can use different configurable options.

The following example starts an Alpine container with the none logging driver.

``docker run -it --log-driver none alpine ash``

Docker provides two modes for delivering messages from the container to the log driver:

- (default) direct, blocking delivery from container to driver
- non-blocking delivery that stores log messages in an intermediate per-container buffer for consumption by driver

The non-blocking message delivery mode prevents applications from blocking due to logging back pressure. Applications are likely to fail in
unexpected ways when STDERR or STDOUT streams block.
> When the buffer is full, new messages will not be enqueued.

The following example starts an Alpine container with log output in non-blocking mode and a 4 megabyte buffer:

``docker run -it --log-opt mode=non-blocking --log-opt max-buffer-size=4m alpine ping 127.0.0.1``

### [Supported logging drivers](https://docs.docker.com/engine/logging/configure/#supported-logging-drivers)

| Driver    | Description                                                                                             |
|-----------|---------------------------------------------------------------------------------------------------------|
| none      | No logs are available for the container, and `docker logs` does not return any output.                  |
| local     | Logs are stored in a custom format designed for minimal overhead.                                       |
| json-file | The logs are formatted as JSON. The default logging driver for Docker.                                  |
| syslog    | Writes logging messages to the syslog facility. The syslog daemon must be running on the host machine.  |
| journald  | Writes log messages to journald. The journald daemon must be running on the host machine.               |
| gelf      | Writes log messages to a Graylog Extended Log Format (GELF) endpoint such as Graylog or Logstash.       |
| fluentd   | Writes log messages to fluentd (forward input). The fluentd daemon must be running on the host machine. |
| awslogs   | Writes log messages to Amazon CloudWatch Logs.                                                          |
| splunk    | Writes log messages to Splunk using the HTTP Event Collector.                                           |
| etwlogs   | Writes log messages as Event Tracing for Windows (ETW) events. Only available on Windows platforms.     |
| gcplogs   | Writes log messages to Google Cloud Platform (GCP) Logging.                                             |

### EFK / ELK stack basics

1. Docker containers generate logs (via the json-file log driver or via Fluentd/Logstash).
1. Fluentd or Logstash collects logs and forwards them to Elasticsearch.
1. Elasticsearch stores the logs and allows fast searching and querying.
1. Kibana provides a web interface to visualize and analyze the logs.

```docker run -d my-docker-image```

Logstash Configuration (logstash.conf)

```aiignore
input {
  file {
    path => "/var/lib/docker/containers/*/*.log"
    start_position => "beginning"
    sincedb_path => "/dev/null"  # Optional: To disable file state tracking (for testing purposes)
    codec => json_lines
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "docker-logs-%{+YYYY.MM.dd}"
    user => "elastic"  # Replace with your Elasticsearch username
    password => "changeme"  # Replace with your Elasticsearch password
    manage_template => false
  }
}
```

```aiignore
docker run -d \
  --name logstash \
  -v /var/lib/docker/containers:/var/lib/docker/containers \
  -v /path/to/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
  docker.elastic.co/logstash/logstash:7.10.0
```

```aiignore
docker run -d \
  --name elasticsearch \
  -p 9200:9200 \
  -e "discovery.type=single-node" \
  docker.elastic.co/elasticsearch/elasticsearch:7.10.0
```

```aiignore
docker run -d \
  --name kibana \
  -p 5601:5601 \
  --link elasticsearch \
  docker.elastic.co/kibana/kibana:7.10.0

```

## Docker compose

Docker Compose is a tool for defining and running multi-container applications.

Compose simplifies the control of your entire application stack, making it easy to manage services, networks, and volumes in a single,
comprehensible YAML configuration file. Then, with a single command, you create and start all the services from your configuration file.

Compose works in all environments; production, staging, development, testing, as well as CI workflows. It also has commands for managing the
whole lifecycle of your application:

- Start, stop, and rebuild services
- View the status of running services
- Stream the log output of running services
- Run a one-off command on a service

### [Docker-compose.yml syntax](https://github.com/compose-spec/compose-spec/blob/main/spec.md)

The default path for a Compose file is `compose.yaml` (preferred) or compose.yml that is placed in the working directory. Compose also
supports `docker-compose.yaml` and `docker-compose.yml` for backwards compatibility of earlier versions. If both files exist, Compose
prefers
the canonical `compose.yaml`.

Compose validates whether it can fully parse the Compose file. If some fields are unknown, typically because the Compose file was written
with fields defined by a newer version of the Specification, you'll receive a warning message. Compose offers options to ignore unknown
fields (as defined by "loose" mode).

The Compose file is a YAML file defining:

- Version (Optional)
- Services (Required)
- Networks
- Volumes
- Configs
- Secrets

```
version: '3.7'  # Version 3.7 is required for configs and secrets

services:
  app:
    image: myapp:latest
    ports:
      - "8080:80"
    environment:
      - VAR_NAME=value
    volumes:
      - ./data:/data
    configs:
      - source: app_config
        target: /etc/app/config.yml
    secrets:
      - app_secret
    networks:
      - app_network

  db:
    image: postgres:latest
    environment:
      - POSTGRES_USER=myuser
      - POSTGRES_PASSWORD=mypassword
    volumes:
      - db_data:/var/lib/postgresql/data
    secrets:
      - db_password
    networks:
      - app_network

volumes:
  db_data: {}

configs:
  app_config:
    file: ./config/app_config.yml  # Path to the config file on your host machine

secrets:
  app_secret:
    file: ./secrets/app_secret.txt  # Path to the secret file on your host machine
  db_password:
    file: ./secrets/db_password.txt  # Path to the secret file on your host machine

networks:
  app_network:
    driver: bridge

```


### CLI basics: up, down, start, stop

The Docker CLI lets you interact with your Docker Compose applications through the docker compose command, and its subcommands. Using the
CLI, you can manage the lifecycle of your multi-container applications defined in the compose.yaml file. The CLI commands enable you to
start, stop, and configure your applications effortlessly.

| Command                  | Description                                                                                                                                    |
|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `docker compose alpha`   | Experimental commands                                                                                                                          |
| `docker compose build`   | Build or rebuild services                                                                                                                      |
| `docker compose config`  | Parse, resolve and render compose file in canonical format                                                                                     |
| `docker compose cp`      | Copy files/folders between a service container and the local filesystem                                                                        |
| `docker compose create`  | Creates containers for a service                                                                                                               |
| `docker compose down`    | Stop and remove containers, networks                                                                                                           |
| `docker compose events`  | Receive real-time events from containers                                                                                                       |
| `docker compose exec`    | Execute a command in a running container                                                                                                       |
| `docker compose images`  | List images used by the created containers                                                                                                     |
| `docker compose kill`    | Force stop service containers                                                                                                                  |
| `docker compose logs`    | View output from containers                                                                                                                    |
| `docker compose ls`      | List running compose projects                                                                                                                  |
| `docker compose pause`   | Pause services                                                                                                                                 |
| `docker compose port`    | Print the public port for a port binding                                                                                                       |
| `docker compose ps`      | List containers                                                                                                                                |
| `docker compose pull`    | Pull service images                                                                                                                            |
| `docker compose push`    | Push service images                                                                                                                            |
| `docker compose restart` | Restart service containers. If you make changes to your compose.yml configuration, these changes are not reflected after running this command. |
| `docker compose rm`      | Removes stopped service containers                                                                                                             |
| `docker compose run`     | Run a one-off command on a service                                                                                                             |
| `docker compose start`   | Start services                                                                                                                                 |
| `docker compose stop`    | Stop services                                                                                                                                  |
| `docker compose top`     | Display the running processes                                                                                                                  |
| `docker compose unpause` | Unpause services                                                                                                                               |
| `docker compose up`      | Create and start containers                                                                                                                    |
| `docker compose version` | Show the Docker Compose version information                                                                                                    |
| `docker compose wait`    | Block until containers of all (or specified) services stop                                                                                     |
| `docker compose watch`   | Watch build context for service and rebuild/refresh containers when files are updated                                                          |






