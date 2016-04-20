#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalJava {
	FILE=/vagrant/resources/$JAVA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

# function setupJava {
# 	echo "setting up java"
# 	ln -s /usr/local/jdk1.7.0_76 /usr/local/java
# 	ln -s /usr/local/java/bin/java /usr/bin/java
# 	ln -s /usr/local/java/bin/javac /usr/bin/javac
# 	ln -s /usr/local/java/bin/jar /usr/bin/jar
# 	ln -s /usr/local/java/bin/javah /usr/bin/javah
# }

function setupEnvVars {
	echo "creating java environment variables"
	# JAVA_HOME=/usr/java/jdk1.8.0_65
	echo export JAVA_HOME="/usr/lib/jvm/java-8-oracle" >> /etc/profile.d/java.sh
	echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh
	chmod +x /etc/profile.d/java.sh
}

function installJava {
	# http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
	add-apt-repository ppa:webupd8team/java
	apt-get -y update
	apt-get -y install openjdk-7-jdk phantomjs
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
	apt-get -y install oracle-java8-installer
}

function installAnt {
	echo "install Ant"
    FILE=/vagrant/resources/$ANT_ARCHIVE
    if resourceExists $ANT_ARCHIVE; then
		echo "install Ant from local file"
	else
		curl -o $FILE -O -L $ANT_MIRROR_DOWNLOAD
	fi
    unzip $FILE -d /usr/local
    ln -s /usr/local/apache-ant-${ANT_VERSION} /usr/local/ant
    # ln -s /usr/local/ant/bin/ant /usr/bin/ant
}

function setupAntEnvVars {
	echo "creating Ant environment variables"
	echo \#!/bin/bash >> /etc/profile.d/ant.sh
	echo export ANT_HOME=/usr/local/ant >> /etc/profile.d/ant.sh
	echo export PATH=\${ANT_HOME}/bin:\${PATH} >> /etc/profile.d/ant.sh
	echo export CLASSPATH=. >> /etc/profile.d/ant.sh
    chmod +x /etc/profile.d/ant.sh
}

function installMaven {
	echo "install Maven"
    FILE=/vagrant/resources/$MAVEN_ARCHIVE
    if resourceExists $MAVEN_ARCHIVE; then
		echo "install Maven from local file"
	else
		curl -o $FILE -O -L $MAVEN_MIRROR_DOWNLOAD
	fi
    unzip $FILE -d /usr/local
    ln -s /usr/local/apache-maven-${MAVEN_VERSION} /usr/local/maven
    ln -s /usr/local/maven/bin/mvn /usr/bin/mvn
}

function setupMavenEnvVars {
	echo "creating Maven environment variables"
	echo \#!/bin/bash >> /etc/profile.d/maven.sh
	echo export MAVEN_HOME=/usr/local/maven >> /etc/profile.d/maven.sh
	echo export PATH=\${MAVEN_HOME}/bin:\${PATH} >> /etc/profile.d/maven.sh
	echo export CLASSPATH=. >> /etc/profile.d/maven.sh
    chmod +x /etc/profile.d/maven.sh
}

echo "setup java"
installJava
setupJava
setupEnvVars
installAnt
setupAntEnvVars
installMaven
setupMavenEnvVars

