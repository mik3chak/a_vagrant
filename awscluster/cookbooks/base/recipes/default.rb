#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'base::test'
#%w{ 200 201 }.each do |no|
#hostsfile_entry "192.168.56.#{no}" do
#  hostname  "node#{no}"
#  action    :create
#end
#end
