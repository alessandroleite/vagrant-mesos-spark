#/bin/bash

service zookeeper stop
/usr/local/zookeeper/bin/zkServer.sh start
/usr/bin/mesos-init-wrapper master &
/usr/bin/marathon &
/usr/bin/chronos &

/usr/local/spark/sbin/start-mesos-dispatcher.sh -m mesos://mesosnode1:5050