#!/usr/bin/env bash
docker build -t health-check .
#restart don't work for healthcheck in this case.
# Docker compose or swarm probably better suit for this case
docker run -itd --name  health-check --restart unless-stopped  health-check
