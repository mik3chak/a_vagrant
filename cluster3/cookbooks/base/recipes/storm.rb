execute "storm_install_supervisor" do
        command "yum clean all; yum install -y supervisor"
        not_if { File.exists?("/usr/bin/supervisord") }
end

execute "storm_download" do
	cwd "/home/vagrant"
	command "wget #{node['reposerver']}/storm/apache-storm-#{node['storm']['version']}.tar.gz"
	notifies :run, "execute[storm_extract]", :immediately
	not_if {File.exists?("/home/vagrant/apache-storm-#{node['storm']['version']}.tar.gz") }
end

execute "storm_extract" do
	cwd "/home/vagrant"
 	command "tar -xzf apache-storm-#{node['storm']['version']}.tar.gz"
	not_if { File.exists?("/home/vagrant/apache-storm-#{node['storm']['version']}") }	
end

user node['user']['storm'] do
home "/home/#{node['user']['storm']}"
        supports :manage_home => false
        action :create
end

group node['user']['storm'] do
        action :create
        members node['user']['storm']
        append true
end

script "storm_install" do
        cwd "/home/vagrant"
        interpreter "bash"
        code <<-EOH
        mv apache-storm-#{node['storm']['version']} /usr/local/
	ln -s /usr/local/apache-storm-#{node['storm']['version']} /usr/local/storm
	chown -R #{node['user']['storm']}:#{node['user']['storm']} /usr/local/storm
	chown -R #{node['user']['storm']}:#{node['user']['storm']} /usr/local/storm/

	mkdir /usr/local/storm/data

	chmod -R 777 /usr/local/storm
        EOH
        #action :nothing
end

directory "/var/log/storm" do
        owner node['user']['storm']
        group node['user']['storm']
        mode '0777'
        action :create
        not_if { File.exists?("/var/log/storm") }
end

script "update_storm.yaml" do
        cwd "/usr/local/storm/conf"
        interpreter "bash"
        code <<-EOH        
	echo '' >> storm.yaml
        echo 'nimbus.host: "#{node['storm']['nimbus']}"' >> storm.yaml
	
	echo '' >> storm.yaml
	echo 'storm.local.dir: "/usr/local/storm/data"' >> storm.yaml

	echo '' >> storm.yaml
	echo 'nimbus.childopts: "-Xmx1024m -Djava.net.preferIPv4Stack=true"' >> storm.yaml

	echo '' >> storm.yaml
	echo 'ui.childopts: "-Xmx768m -Djava.net.preferIPv4Stack=true"' >> storm.yaml

	echo '' >> storm.yaml
	echo 'supervisor.childopts: "-Djava.net.preferIPv4Stack=true"' >> storm.yaml

	echo '' >> storm.yaml
	echo 'worker.childopts: "-Xmx768m -Djava.net.preferIPv4Stack=true"' >> storm.yaml

	echo '' >> storm.yaml
	echo 'storm.zookeeper.servers:' >> storm.yaml
	EOH
end

node['zk']['servers'].each do |key, value|        
script "update_zk_servers_for_storm" do
	cwd "/usr/local/storm/conf"
	interpreter "bash"
	code <<-EOH
	echo '    - "#{value}"' >> storm.yaml
	EOH
end
end

script "start_supervisord_in_startup" do
	interpreter "bash"
        code <<-EOH
        chkconfig supervisord --level 234 on
	EOH
end

#node['storm']['supervisor']['nimbus'].each do |key, value|
#script "update_supervisord_conf_nimbus" do
#        interpreter "bash"
#        code <<-EOH
#        echo '#{value}' >> /etc/supervisord.conf
#        EOH
#end
#end
#
#node['storm']['supervisor']['ui'].each do |key, value|
#script "update_supervisord_conf_ui" do
#        interpreter "bash"
#        code <<-EOH
#        echo '#{value}' >> /etc/supervisord.conf
#        EOH
#end
#end
#
#node['storm']['supervisor']['slave'].each do |key, value|
#script "update_supervisord_conf_slave" do
#        interpreter "bash"
#        code <<-EOH
#        echo '#{value}' >> /etc/supervisord.conf
#        EOH
#end
#end
#
#execute "start_supervisord" do
#	command "service supervisord restart"
#end

# if fine, http://192.168.56.207:8080
