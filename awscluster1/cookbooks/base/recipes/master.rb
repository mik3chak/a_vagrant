include_recipe 'base::test'

#%w{ node['user']['hdfs'] }.each do |usr|
#node['user']['hdfs'].each do |usr|
#	user usr do
	user node['user']['hdfs'] do
		home "/home/#{node['user']['hdfs']}"
		supports :manage_home => true	
		action :create
	end
#end

directory "/home/#{node['user']['hdfs']}/.ssh" do
        owner node['user']['hdfs']
        group node['user']['hdfs']
        mode '0700'
        action :create
        recursive true
        not_if { File.exists?("/home/#{node['user']['hdfs']}/.ssh") }
end

file "/home/#{node['user']['hdfs']}/.ssh/known_hosts" do
        mode '0600'
        owner node['user']['hdfs']
        group node['user']['hdfs']
        action :create_if_missing
end

template "/home/#{node['user']['hdfs']}/.ssh/config" do
        source "sshconfig.erb"
        owner node['user']['hdfs']
        group node['user']['hdfs']
        mode "0600"
        not_if { File.exists?("/home/#{node['user']['hdfs']}/.ssh/config") }
end

template "/home/#{node['user']['hdfs']}/.ssh/id_rsa" do
        source "id_rsa.erb"
        owner node['user']['hdfs']
	group node['user']['hdfs']
        mode "0600"
        not_if { File.exists?("/home/#{node['user']['hdfs']}/.ssh/id_rsa") }
end

template "/home/#{node['user']['hdfs']}/.ssh/id_rsa.pub" do
        source "id_rsa.pub.erb"
        owner node['user']['hdfs']
	group node['user']['hdfs']
        mode "0600"
	#notifies :run, "execute[add_localhost_to_known_hosts]", :immediately
        not_if { File.exists?("/home/#{node['user']['hdfs']}/.ssh/id_rsa.pub") }
end

template "/home/#{node['user']['hdfs']}/.ssh/authorized_keys" do
        source "id_rsa.pub.erb"
        owner node['user']['hdfs']
        group node['user']['hdfs']
        mode "0600"
        notifies :run, "execute[add_localhost_to_known_hosts]", :immediately
        not_if { File.exists?("/home/#{node['user']['hdfs']}/.ssh/authorized_keys") }
end

execute "add_localhost_to_known_hosts" do
	user node['user']['hdfs']
	command "ssh-keyscan localhost >> /home/#{node['user']['hdfs']}/.ssh/known_hosts"
	action :nothing
end

#%w{ 1..(node['maxnodes']).to_i }.each do |num|
#num = 1
num = node['startnodeno']
while num <= node['endnodeno'].to_i
	execute "add_other_nodes_to_known_hosts" do
		user node['user']['hdfs']
		#command "ssh-keyscan node#{200 + num} >> /home/#{node['user']['hdfs']}/.ssh/known_hosts"
		command "ssh-keyscan #{node['hostnameformat']}#{200 + num} >> /home/#{node['user']['hdfs']}/.ssh/known_hosts"
		#not_if { File.exists?("/home/vagrant/known_hosts") }
	end
	num += 1
end
