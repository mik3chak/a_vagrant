include_recipe 'base::hbase'

execute "install_hbasemaster" do
        command "yum clean all; yum install -y hbase-master"
        not_if { File.exists?("/etc/rc.d/init.d/hbase-master") }
end

execute "start_hbasemaster" do
	only_if { File.exists?("/etc/rc.d/init.d/hbase-master") }
        command "service hbase-master start"
end

