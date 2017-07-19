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

%w{ 203 204 }.each do |no|
#<% if node['ipaddress'] == "192.168.56.#{no}" -%>
hostsfile_entry "10.0.0.#{no}" do
  #hostname  "node#{no}"
  hostname  "ip-10-0-0-#{no}"	
  action    :create
end
#<% end -%>
end

