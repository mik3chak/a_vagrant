#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

#%w{
#	vim
#	ntp
#}.each do |pkg|
#	package pkg do
#		action :install
#	end
#end

execute "install_ntp" do
	command "yum install -y ntp"
	#notifies :run, "execute[start_ntpd_on_boot]", :immediately
	notifies :run, "script[setup_ntp]", :immediately
	not_if { File.exists?("/usr/sbin/ntpd") }
end

execute "start_ntpd_on_boot" do 
	command "chkconfig ntpd on" 
	#notifies :run, "execute[install_ntp]", :immediately
	#not_if { File.exists?("/usr/sbin/ntpd") == 'false' }
	action :nothing
end

script "setup_ntp" do
	interpreter "bash"
	code <<-EOH
		yum install -y ntp
		chkconfig ntpd on
		service ntpd stop
		ntpdate time.nist.gov
		service ntpd start
	EOH
	action :nothing
#	not_if { File.exists?("/usr/sbin/ntpd") }
end

execute "install_java8" do 
	command "yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel" 
	notifies :run, "ruby_block[set_env_java_home]", :immediately
	not_if { File.exists?("/usr/lib/jvm") }
end

ruby_block "set_env_java_home" do
	block do
    		ENV["JAVA_HOME"] = "/usr/lib/jvm/java-1.8.0-openjdk"
	end
	action :nothing
end

execute "env_var" do
	command "echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk' >> /home/vagrant/.bashrc"
	action :nothing
end

script "disable_ipv6" do
	interpreter "bash"
	code <<-EOH
		echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
		echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
	EOH
	action :nothing
end

execute "selinux_setting" do
	command "sed -i -e 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config"
	action :nothing
end


