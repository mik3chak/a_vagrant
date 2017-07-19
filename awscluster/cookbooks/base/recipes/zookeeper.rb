include_recipe 'base::cloudera'

user node['user']['zookeeper'] do
	home "/home/#{node['user']['zookeeper']}"
	supports :manage_home => false	
	action :create
end

group node['group']['zookeeper'] do
	action :create
	members node['user']['zookeeper']
	append true
end

directory '/var/lib/zookeeper' do
        owner node['group']['zookeeper']
        group node['user']['zookeeper']
        mode '0755'
        action :create
        recursive true
        not_if { File.exists?("/var/lib/zookeeper") }
end

execute "install_zk" do
	command "yum clean all; yum install -y zookeeper zookeeper-server"
	not_if { File.exists?("/etc/zookeeper") }
end

if node['zk']['running'] == node['zk']['totalservers']
	node.default['zk']['running'] = 0
end

if node['zk']['totalservers'] == 1
	node.default['zk']['running'] = 1
else
	node.default['zk']['running'] = node['zk']['running'] + 1	
end

#<% node['zk']['servers'].each do |key, value| -%>
if node['zk']['totalservers'] > 1
node['zk']['servers'].each do |key, value|
	#bash "update_zk_servers" do
	#	code <<-EOF
	#	command -c 'echo "server.#{key}=#{value}:2888:3888" >> /etc/zookeeper/conf/zoo.cfg'
	#	EOF
	#end
	script "update_zk_servers" do
	interpreter "bash"
	code <<-EOH
		bash -c 'echo "server.#{key}=#{value}:2888:3888" >> /etc/zookeeper/conf/zoo.cfg'
	EOH
	end
end
end
#<% end %>

script "zk_post_installation" do
        interpreter "bash"
        code <<-EOH
                service zookeeper-server init --myid=#{node['zk']['running']}
                service zookeeper-server start
        EOH
        not_if { File.exists?("/var/lib/zookeeper/version-2") }
end

