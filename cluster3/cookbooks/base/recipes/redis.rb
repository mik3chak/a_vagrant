execute "redis_download" do
	cwd "/home/vagrant"
	command "wget #{node['reposerver']}/redis/redis-#{node['redis']['version']}.tar.gz"
	notifies :run, "execute[redis_install]", :immediately
	not_if {File.exists?("/home/vagrant/redis-#{node['redis']['version']}.tar.gz") }
end

execute "redis_install" do
	cwd "/home/vagrant"
 	command "tar -xzf redis-#{node['redis']['version']}.tar.gz"
	not_if { File.exists?("/home/vagrant/redis-#{node['redis']['version']}") }	
end

script "start_redis" do
        cwd "/home/vagrant/redis-#{node['redis']['version']}"
        interpreter "bash"
        code <<-EOH
	src/redis-server	
	EOH
	#action :nothing
end

#$ src/redis-cli
#redis> set foo bar
#OK
#redis> get foo
#"bar"
