include_recipe 'base::cloudera'

execute "install_flume" do
	command "yum clean all; yum install -y flume-ng"
	not_if { File.exists?("/usr/bin/flume-ng") }
end

execute "new_env" do
	command "cp /etc/flume-ng/conf/flume-env.sh.template /etc/flume-ng/conf/flume-env.sh"
	not_if { File.exists?("/etc/flume-ng/conf/flume-env.sh") }
end

#execute "set_env_var" do
#	only_if {"cat /home/vagrant/.bashrc | grep HADOOP_MAPRED_HOME"}
#        command "echo 'export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce' >> /home/vagrant/.bashrc"
#	
#end

#script "set_env_var" do
#	only_if {"cat /home/vagrant/.bashrc | grep HADOOP_MAPRED_HOME" }
#	interpreter "bash"
#	code <<-EOH
#				
#		echo 'export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce'
#		source ~/.bashrc
#	EOH
#
#end
