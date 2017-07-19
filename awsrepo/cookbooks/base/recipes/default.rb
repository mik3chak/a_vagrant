directory '/var/www/lighttpd' do
        #owner 'vagrant'
        #group 'vagrant'
        mode '0755'
        action :create
        recursive true
        not_if { File.exists?("/var/www/lighttpd") }
	action :nothing
end

execute "install" do
	command "yum install -y yum-utils createrepo yum-plugin-downloadonly"
	#notifies :run, "script[post_install]", :immediately
	#not_if { File.exists?("/etc/lighttpd/lighttpd.conf") }
	not_if { File.exists?("/usr/bin/createrepo") }
end

script "install_lighttpd" do
	cwd '/home/vagrant/'
	interpreter "bash"
	code <<-EOH
		wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
		rpm -Uhv rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
		yum install -y lighttpd
	EOH
	notifies :run, "script[post_install]", :immediately
	not_if { File.exists?("/etc/lighttpd/lighttpd.conf") }
end

script "post_install" do
	interpreter "bash"
	code <<-EOH
		chkconfig --levels 235 lighttpd on
		service lighttpd start
	EOH
	action :nothing        
end

directory "#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS/noarch" do
	#owner 'vagrant'
	#group 'vagrant'
	mode '0755'
	action :create
	recursive true
	not_if { File.exists?("#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS/noarch") }
end

directory "#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS/x86_64" do
	#owner 'vagrant'
	#group 'vagrant'
	mode '0755'
	action :create
	recursive true
	not_if { File.exists?("#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS/x86_64") }
end

# do manual download/copy from local host due to large amount of files

template "/etc/yum.repos.d/cloudera-cdh5.repo" do
	source "default.conf.erb"
	owner "root"
	mode "0644"
	#notifies :run, "script[yum_operation]", :immediately
	not_if { File.exists?("/etc/yum.repos.d/cloudera-cdh5.repo") }
end

#execute "install2" do
#        command "yum install -y yum-plugin-downloadonly"
#        #notifies :run, "execute[post_install2]", :immediately
#	#notifies :run, "script[download_all]", :immediately
#end

#execute "post_install2" do
#        command "yum install -y --downloadonly --downloaddir=/home/vagrant zookeeper-server"
#end

script "download_all" do
	interpreter "bash"
	code <<-EOH
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS/ zookeeper-server
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-hdfs-namenode
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-hdfs-datanode
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-hdfs-secondarynamenode
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-mapreduce
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-mapreduce-historyserver
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-yarn-proxyserver
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-yarn-resourcemanager
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-yarn-nodemanager	
		yum install -y --downloadonly --downloaddir=#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/RPMS hadoop-client

	EOH
	#action :nothing
end
# do manual download/copy from local host due to large amount of files

script "yum_operation" do
	cwd "#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2"
	interpreter "bash"
	code <<-EOH
		createrepo .
		yum makecache
	EOH
	not_if { File.exists?("#{node['lighttpd']['server_root']}/lighttpd/cdh/5.4.2/repodata") }
end

execute "stop_iptables" do
	command 'service iptables stop'
end
