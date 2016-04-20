Vagrant.require_version ">= 1.7.1"
VAGRANTFILE_API_VERSION = "2"

unless Vagrant.has_plugin?("vagrant-docker-compose")
  system("vagrant plugin install vagrant-docker-compose")
  puts "Dependencies installed, restarting vagrant again ..."
  exec "vagrant #{ARGV.join(' ')}"
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	num_nodes = 2
	r = num_nodes..1
	(r.first).downto(r.last).each do |i|
		config.vm.define "mesosnode#{i}" do |node|
			node.vm.box = "ubuntu"
			node.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

			node.vm.provider "virtualbox" do |v|
			    v.name = "mesosnode#{i}"
			    v.customize ["modifyvm", :id, "--memory", "1536"]

			    if i == 1
			        v.customize ["modifyvm", :id, "--memory", "2048"]
			    end
			end

			if i < 10
				node.vm.network :private_network, ip: "10.211.56.10#{i}"
			else
				node.vm.network :private_network, ip: "10.211.56.1#{i}"
			end

			node.vm.hostname = "mesosnode#{i}"

			node.vm.provision "shell", path: "scripts/setup-ubuntu.sh"
			node.vm.provision "shell", path: "scripts/setup-ubuntu-ntp.sh"

			# Install Docker
			node.vm.provision :docker
			node.vm.provision "shell", path: "scripts/setup-docker.sh"

			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-ubuntu-hosts.sh"
				s.args = "-t #{num_nodes}"
			end

			node.vm.provision "shell", path: "scripts/setup-java.sh"
			node.vm.provision "shell", path: "scripts/setup-scala.sh"
			node.vm.provision "shell", path: "scripts/setup-go.sh"
			
			node.vm.provision "shell", path: "scripts/setup-zookeeper.sh"
			node.vm.provision "shell", path: "scripts/setup-etcd.sh"
			node.vm.provision "shell", path: "scripts/setup-spark.sh"

			if i == 1
				node.vm.provision "shell", path: "scripts/setup-mesos.sh"
				node.vm.provision "shell", 
				     path: "scripts/start-master-applications.sh", 
				     privileged:true, 
				     run: "always"
				node.vm.post_up_message = "
				   Mesos' GUI: http://10.211.56.101:5050
				   Mesos Chronos: http://10.211.56.101:4400
				   Spark Driver for Mesos Cluster: http://10.211.56.101:8081
				   Marathon: http://10.211.56.101:8080
				   Example of job Spark: 
				   spark-submit --deploy-mode cluster --master mesos://mesosnode1:7077 --executor-memory 512m --executor-cores 1 --class org.apache.spark.examples.SparkPi $SPARK_HOME/lib/spark-examples-1.6.1-hadoop2.6.0.jar 100"
			else
				node.vm.provision "shell", path: "scripts/setup-mesosslave.sh"
				node.vm.provision "shell", 
				     path: "scripts/start-mesosslave-applications.sh", 
				     run: "always",
				     privileged:true
			end
		end
	end
end
