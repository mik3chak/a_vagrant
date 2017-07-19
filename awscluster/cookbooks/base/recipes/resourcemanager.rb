include_recipe 'base::cloudera'

execute "install_RM" do
        command "yum clean all; yum install -y hadoop-yarn-resourcemanager"
	notifies :run, "execute[start_RM]", :immediately
	not_if { File.exists?("/etc/default/hadoop-yarn-resourcemanager") }
end

execute "start_RM" do
        command "service hadoop-yarn-resourcemanager start"
	action :nothing
end
