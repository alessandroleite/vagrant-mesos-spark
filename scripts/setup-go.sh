#!/bin/bash
source "/vagrant/scripts/common.sh"

# install swarm https://github.com/docker/swarm/ http://docs.docker.com/swarm/
# http://docs.docker.com/swarm/discovery/ http://matthewkwilliams.com/index.php/2015/04/03/swarming-raspberry-pi-docker-swarm-discovery-options/

apt-get install -y git cgdb bison

FILE=/vagrant/resources/go1.6.linux-amd64.tar.gz
if resourceExists go1.6.linux-amd64.tar.gz; then
	echo "install golang from local file"
else
	curl -o $FILE -O -L https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
fi

tar -C /usr/local -xzf $FILE

GOPATH=/usr/local/src/gocode

/bin/mkdir -p ${GOPATH}
echo export GOPATH=${GOPATH} >> /etc/profile.d/go.sh
echo export PATH=${GOPATH}/bin:/usr/local/go/bin:\$PATH >> /etc/profile.d/go.sh
chmod +x /etc/profile.d/go.sh
source /etc/profile.d/go.sh
go get github.com/tools/godep
