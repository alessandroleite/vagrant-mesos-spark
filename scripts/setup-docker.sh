#!/bin/bash
source "/vagrant/scripts/common.sh"

# Configure docker daemon to bind to both TCP and domain socket
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"' >> /etc/default/docker
service docker stop && service docker start

# install docker compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose