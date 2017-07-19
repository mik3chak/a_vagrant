#kafka_2.11-0.8.2.1.tgz

execute "kafka_download" do
	cwd "/home/vagrant"
	#command "wget #{node['reposerver']}/kafka/kafka_2.11-0.8.2.1.tgz"
	command "wget #{node['reposerver']}/kafka/kafka_#{node['kafka']['version']}.tgz"
	notifies :run, "execute[kafka_install]", :immediately
	not_if {File.exists?("/home/vagrant/kafka_#{node['kafka']['version']}.tgz") }
end

execute "kafka_install" do
	cwd "/home/vagrant"
 	command "tar -xzf kafka_#{node['kafka']['version']}.tgz"
	not_if { File.exists?("/home/vagrant/kafka_#{node['kafka']['version']}") }	
end

zkEnsemble = "";
node['zk']['servers'].each do |key, value|
        zkEnsemble = zkEnsemble + "#{value}:2181,"
end
zkEnsemble = zkEnsemble.chomp(',')

script "update_kafka_properties" do
        cwd "/home/vagrant/kafka_#{node['kafka']['version']}"
        interpreter "bash"
        code <<-EOH
	chown -R vagrant:vagrant /home/vagrant/kafka_#{node['kafka']['version']}
	sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=#{zkEnsemble}/' config/server.properties

        EOH
end

directory "/tmp/kafka-logs" do
	#owner node['user']['hdfs']
        #group node['user']['hdfs']
        mode '0777'
        action :create
        not_if { File.exists?('/tmp/kafka-logs') }
end

if node['kafka']['totalservers'] > 1
node['kafka']['servers'].each do |key, value|
        script "create_kafka_properties" do
	cwd "/home/vagrant/kafka_#{node['kafka']['version']}"
        interpreter "bash"
        code <<-EOH
		cp config/server.properties config/server-#{key}.properties
		sed -i 's/broker.id=0/broker.id=#{key}/' config/server-#{key}.properties
		sed -i 's/port=9092/port=909#{key.to_i + 2}/' config/server-#{key}.properties
		sed -i 's/log.dirs=\\/tmp\\/kafka-logs/log.dirs=\\/tmp\\/kafka-logs-#{key}/' config/server-#{key}.properties

		sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=#{zkEnsemble}/' config/server-#{key}.properties

		mkdir /tmp/kafka-logs-#{key}
		chmod -R go+w /tmp/kafka-logs-#{key}
        EOH
        end
end
end

#execute "start_main_kafka_server" do
#	cwd "/home/vagrant/kafka_#{node['kafka']['version']}"
#        command "bin/kafka-server-start.sh config/server.properties"
#end

script "start_main_kafka_server" do
        cwd "/home/vagrant/kafka_#{node['kafka']['version']}"
        interpreter "bash"
        code <<-EOH
	
	chmod -R go+w /tmp/kafka-logs
	bin/kafka-server-start.sh config/server.properties
	EOH
	action :nothing
end

node['kafka']['servers'].each do |key, value|
	execute "start_other_kafka_server" do
		cwd "/home/vagrant/kafka_#{node['kafka']['version']}"
		command "bin/kafka-server-start.sh config/server-#{key}.properties"
		action :nothing
	end
end
