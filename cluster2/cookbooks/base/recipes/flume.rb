include_recipe 'base::cloudera'

execute "install_flume" do
	command "yum clean all; yum install -y flume-ng"
	not_if { File.exists?("/usr/bin/flume-ng") }
end

#execute "set_env_var" do
#	only_if {"cat /home/vagrant/.bashrc | grep HADOOP_MAPRED_HOME"}
#        command "echo 'export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce' >> /home/vagrant/.bashrc"
#	
#end
