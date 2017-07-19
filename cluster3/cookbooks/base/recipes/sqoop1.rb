#include_recipe 'base::cloudera'

execute "install_sqoop" do
	command "yum clean all; yum install -y sqoop"
	not_if { File.exists?("/usr/bin/sqoop") }
end

execute "install_mysql_connector" do
        command "yum clean all; yum install -y mysql-connector-java"
        not_if { File.exists?("/usr/share/java/mysql-connector-java.jar") }
end

execute "set_env_var" do
	only_if {"cat /home/vagrant/.bashrc | grep HADOOP_MAPRED_HOME"}
        command "echo 'export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce' >> /home/vagrant/.bashrc"
	
end
