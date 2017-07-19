include_recipe 'base::cloudera'

execute "install_hcatalog" do
	command "yum clean all; yum install -y hive-hcatalog"
	not_if { File.exists?("/usr/bin/hcat") }
end

#execute "start_hcatalog" do
#end
