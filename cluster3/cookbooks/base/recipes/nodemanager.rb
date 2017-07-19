include_recipe 'base::cloudera'

execute "install_NM" do
        command "yum clean all; yum install -y hadoop-yarn-nodemanager"
	notifies :run, "execute[start_NM]", :immediately
	not_if { File.exists?("/etc/default/hadoop-yarn-nodemanager") }
end

execute "start_NM" do
        command "service hadoop-yarn-nodemanager start"
	action :nothing
end
