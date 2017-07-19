include_recipe 'base::cloudera'

execute "install_hive" do
	command "yum clean all; yum install -y hive hive-server2"
	#notifies :run, "execute[install_mysql_connector]", :immediately
	not_if { File.exists?("/usr/bin/hive") }
end

if node['hive']['remotemetastore'] == 1
execute "install_hive_metastore" do
	command "yum clean all; yum install -y hive-metastore"
	not_if { File.exists?("/etc/default/hive-metastore") }
end
end

execute "install_mysql_connector" do
	command "yum clean all; yum install -y mysql-connector-java"
	notifies :run, "execute[setup_mysql_connector]", :immediately
	not_if { File.exists?("/usr/share/java/mysql-connector-java.jar") }
	#action :nothing
end

execute "setup_mysql_connector" do
	command "ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/mysql-connector-java.jar"
	action :nothing
end

if node['hive']['remotemetastore'] == 1
template "/usr/lib/hive/conf/hive-site.xml" do
	only_if { File.exists?("/usr/lib/hive/conf/hive-site.xml") }
        source "hive-site.xml.erb"
end
end

script "setup_hdfs_directories" do
        interpreter "bash"
        code <<-EOH
                sudo -u hdfs hadoop fs -mkdir -p /user/hive/warehouse
		sudo -u hdfs hadoop fs -chmod -R 1777 /user/hive
                touch /home/vagrant/setup_hdfs
        EOH
        not_if { File.exists?("/home/vagrant/setup_hdfs") }
end

execute "set_env_var" do
	only_if {"cat /home/vagrant/.bashrc | grep HADOOP_MAPRED_HOME"}
        command "echo 'export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce' >> /home/vagrant/.bashrc"
	
end

if node['hive']['remotemetastore'] == 1
execute "start_metastore" do
	command "service hive-metastore restart"
	#not_if { "service hive-metastore status | grep running" }
end
end

execute "start_hive" do
	#only_if { File.exists?("/home/vagrant/setup_hdfs") }
        command "service hive-server2 restart"        
	#not_if { "service hive-server2 status | grep running" }
end
