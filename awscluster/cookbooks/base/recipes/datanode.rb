include_recipe 'base::cloudera'

user node['user']['hdfs'] do
home "/home/#{node['user']['hdfs']}"
	supports :manage_home => true	
	action :create
end

user node['user']['yarn'] do
home "/home/#{node['user']['yarn']}"
	supports :manage_home => false	
	action :create
end

group node['user']['hdfs'] do
	action :create
	members node['user']['hdfs']
	append true
end

group node['user']['yarn'] do
	action :create
	members node['user']['yarn']
	append true
end

%w{ 1 2 3 4 }.each do |num|
directory "/data/#{num}/dfs/dn" do
        owner node['user']['hdfs']
        group node['user']['hdfs']
        #mode '0755'
	mode '0700'
        action :create
        recursive true
        not_if { File.exists?("/data/#{num}/dfs/dn") }
        #action :nothing
end
end

%w{ local logs }.each do |type|
        %w{ 1 2 3 4 }.each do |num|
                directory "/data/#{num}/yarn/#{type}" do
                        owner node['user']['yarn']
                        group node['user']['yarn']
                        mode '0755'
                        action :create
                        recursive true
                        not_if { File.exists?("/data/#{num}/yarn/#{type}") }
                end
        end
end

execute "install_DN" do
command "yum clean all; yum install -y hadoop-hdfs-datanode"
#action :nothing
notifies :run, "execute[install_client]", :immediately
not_if { File.exists?("/etc/default/hadoop-hdfs-datanode") }
end

execute "install_client" do
        command "yum clean all; yum install -y hadoop-client"
	action :nothing
	notifies :run, "execute[install_done]", :immediately
	not_if { File.exists?("/usr/lib/hadoop/client") }
end

execute "install_done" do
        command "touch /home/vagrant/install_done"
        action :nothing
end

script "post_install" do
	only_if { File.exists?("/home/vagrant/install_done") }
	interpreter "bash"
	code <<-EOH
		cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.my_cluster
		alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.my_cluster 50
		alternatives --set hadoop-conf /etc/hadoop/conf.my_cluster
	EOH
	not_if { File.exists?("/etc/hadoop/conf.my_cluster") }
end

template "/etc/hadoop/conf/core-site.xml" do
	only_if { File.exists?("/etc/hadoop/conf.my_cluster") }
        source "core-site.xml.erb"
end

template "/etc/hadoop/conf/hdfs-site.xml" do
	only_if { File.exists?("/etc/hadoop/conf.my_cluster") }
        source "hdfs-site.xml.erb"
end

template "/etc/hadoop/conf/mapred-site.xml" do
	only_if { File.exists?("/etc/hadoop/conf.my_cluster") }
        source "mapred-site.xml.erb"
end

template "/etc/hadoop/conf/yarn-site.xml" do
	only_if { File.exists?("/etc/hadoop/conf.my_cluster") }
        source "yarn-site.xml.erb"
end

execute "start_DN" do
	only_if { File.exists?("/etc/hadoop/conf.my_cluster") }
        command "service hadoop-hdfs-datanode start"
end
