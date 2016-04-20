#!/bin/bash
source "/vagrant/scripts/common.sh"

#http://mesosphere.com/docs/getting-started/datacenter/install/
#/usr/bin/mesos-init-wrapper

function setupMesos {
	echo "zk://mesosnode1:2181/mesos" > /etc/mesos/zk
	echo "1" > /etc/mesos-master/quorum
	#disable auto start of upstart
	rm -rf /etc/init/zookeeper.conf
	rm -rf /etc/init/mesos-master.conf
	rm -rf /etc/init/marathon.conf
	rm -rf /etc/init/mesos-slave.conf
	rm -rf /etc/init/chronos.conf
	mkdir -p /etc/marathon/conf
	echo '604800' > /etc/marathon/conf/task_launch_timeout
}

function installMesos {
	echo "install mesos"
    #https://mesosphere.com/docs/tutorials/install_ubuntu_debian/#step-0 http://mesos.apache.org/gettingstarted/
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
	DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
	CODENAME=$(lsb_release -cs)
	echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" |  sudo tee /etc/apt/sources.list.d/mesosphere.list
	apt-get -y update
	#to build mesos source code/framework http://mesos.apache.org/gettingstarted/
	apt-get -y install g++
	apt-get -y install autoconf libtool
	apt-get -y install build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev
	apt-get -y install mesos marathon chronos
}

echo "setup mesos"
installMesos
setupMesos
