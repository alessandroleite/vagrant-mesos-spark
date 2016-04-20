#!/bin/bash
source "/vagrant/scripts/common.sh"

function setupEnvVars {
	echo "creating spark environment variables"
	cp -f $SPARK_RES_DIR/spark.sh /etc/profile.d/spark.sh
}

function installSpark {
	echo "install spark"
	FILE=/vagrant/resources/$SPARK_ARCHIVE
    if resourceExists $SPARK_ARCHIVE; then
		echo "install spark from local file"
	else
		echo $SPARK_MIRROR_DOWNLOAD
        curl -o $FILE -O -L $SPARK_MIRROR_DOWNLOAD
	fi
	tar -xzf $FILE -C /usr/local
	ln -s /usr/local/$SPARK_VERSION /usr/local/spark
	chown -R vagrant:vagrant /usr/local/spark/
}

echo "Installing Spark"
installSpark
setupEnvVars