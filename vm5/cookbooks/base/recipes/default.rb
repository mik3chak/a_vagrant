#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

execute "update" do
	command "yum update -y"
	not_if { File.exists?("/usr/sbin/ntpd") }
end

execute "install_wget" do
	command "yum install -y wget"
	not_if { File.exists?("/usr/bin/wget") }
end

execute "install_telnet" do
        command "yum install -y telnet"
        not_if { File.exists?("/usr/bin/telnet") }
end

execute "install_tree" do
        command "yum install -y tree"
        not_if { File.exists?("/usr/bin/tree") }
end

execute "install_nmap" do
        command "yum install -y nmap"
        not_if { File.exists?("/usr/bin/nmap") }
end

execute "install_ntp" do
	command "yum install -y ntp"
	notifies :run, "script[setup_ntp]", :immediately
	not_if { File.exists?("/usr/sbin/ntpd") }
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
end

execute "install_java8" do 
	command "yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel" 
	notifies :run, "execute[set_java_env_var]", :immediately
	not_if { File.exists?("/usr/lib/jvm") }
end

execute "set_java_env_var" do
	command "echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk' >> /home/vagrant/.bashrc"
	notifies :run, "script[setup_hadoop_node]", :immediately
	action :nothing
end

script "setup_hadoop_node" do
	interpreter "bash"
	code <<-EOH
		echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
		echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
		sed -i -e 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
	EOH
	notifies :reboot_now, "reboot[now]", :immediately
	action :nothing
end

reboot "now" do	
	action :nothing
	reason "IPv6 changes to take effect."
	delay_mins 1
end


