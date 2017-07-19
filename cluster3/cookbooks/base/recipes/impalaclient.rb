#include_recipe 'base::cloudera'

execute "install_impala_client" do
	command "yum clean all; yum install -y impala-shell"
	not_if { File.exists?("/usr/bin/impala") }
end
