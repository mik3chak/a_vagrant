#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# after vagrant initial setup, hosts file will contains:
# 127.0.0.1	node203 localhost localhost.localdomain localhost4 localhost4.localdomain4
# need to remove node203
execute "hosts_setting" do
        command "sed -i -e 's/#{node['hostname']}//' /etc/hosts"        
end

#%w{ 203 204 }.each do |no|
##<% if node['ipaddress'] == "192.168.56.#{no}" -%>
#hostsfile_entry "192.168.56.#{no}" do
#  hostname  "node#{no}"
#  action    :create
#end
##<% end -%>
#end

num = node['startnodeno']
while num <= node['endnodeno'].to_i
#if node['hostname'] != "node#{200 + num}"
	hostsfile_entry "192.168.56.#{200 + num}" do
  		hostname  "node#{200 + num}"
  		action    :create
	end
#end
num += 1
end
