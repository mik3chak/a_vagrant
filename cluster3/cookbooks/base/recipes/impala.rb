#include_recipe 'base::cloudera'

execute "install_impala" do
	command "yum clean all; yum install -y impala impala-server impala-state-store impala-catalog"
	not_if { File.exists?("/usr/bin/impala") }
end
