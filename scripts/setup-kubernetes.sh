#!/bin/bash

# install k8s on top of mesos 
# https://github.com/kubernetes/kubernetes/blob/release-1.1/docs/getting-started-guides/mesos.md

cd /usr/local/src
git clone https://github.com/kubernetes/kubernetes
cd kubernetes
git checkout -b release-1.1 -t remotes/origin/release-1.1
export KUBERNETES_CONTRIB=mesos
make
cp -f /vagrant/resources/k8smesos/k8smesos.sh /etc/profile.d/k8smesos.sh
chmod +x /etc/profile.d/k8smesos.sh
cp -f /vagrant/resources/k8smesos/mesos-cloud.conf /usr/local/src/kubernetes/mesos-cloud.conf