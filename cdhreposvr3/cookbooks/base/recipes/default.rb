execute "install" do
	command "yum clean all; yum install -y yum-utils createrepo lighttpd"
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

directory '/var/www/lighttpd/cdh/5.4.2/RPMS/noarch' do
	#owner 'vagrant'
	#group 'vagrant'
	mode '0755'
	action :create
	recursive true
	not_if { File.exists?("/var/www/lighttpd/cdh/5.4.2/RPMS/noarch") }
end

directory '/var/www/lighttpd/cdh/5.4.2/RPMS/x86_64' do
	#owner 'vagrant'
	#group 'vagrant'
	mode '0755'
	action :create
	recursive true
	not_if { File.exists?("/var/www/lighttpd/cdh/5.4.2/RPMS/x86_64") }
end

# do manual download/copy from local host due to large amount of files

template "/etc/yum.repos.d/cloudera-cdh5.repo" do
	source "default.conf.erb"
	owner "root"
	mode "0644"
	notifies :run, "script[yum_operation]", :immediately
	not_if { File.exists?("/etc/yum.repos.d/cloudera-cdh5.repo") }
end

script "yum_operation" do
	cwd '/var/www/lighttpd/cdh/5.4.2'
	interpreter "bash"
	code <<-EOH
		createrepo .
		yum makecache
	EOH
	not_if { File.exists?("/var/www/lighttpd/cdh/5.4.2/repodata") }
end
