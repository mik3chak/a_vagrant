include_recipe 'base::cloudera'

execute "install_crunch" do
	command "yum clean all; yum install -y crunch"
	not_if { File.exists?("/usr/lib/crunch") }
end

#execute "set_env_var" do
#	only_if {"cat /home/vagrant/.bashrc | grep HADOOP_MAPRED_HOME"}
#        command "echo 'export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce' >> /home/vagrant/.bashrc"
#	
#end
