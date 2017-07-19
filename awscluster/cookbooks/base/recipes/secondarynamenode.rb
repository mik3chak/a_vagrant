include_recipe 'base::cloudera'

execute "install_SNN" do
        command "yum clean all; yum install -y hadoop-hdfs-secondarynamenode"
	notifies :run, "execute[start_SNN]", :immediately
	not_if { File.exists?("/etc/default/hadoop-hdfs-secondarynamenode") }
end

execute "start_SNN" do
        command "service hadoop-hdfs-secondarynamenode start"
end
