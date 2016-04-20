#!/bin/bash
source "/vagrant/scripts/common.sh"

function disableFirewall {
	echo "disabling firewall"
	/sbin/iptables-save
	ufw disable
}

function installUtilities {
	echo "install utilities"

	apt-get -y update 
	apt-get -y install curl python-software-properties \
	                   software-properties-common unzip
}
echo "setup ubuntu"

disableFirewall
installUtilities