include_recipe 'base::hbase'

execute "install_hbaseregionserver" do
        command "yum clean all; yum install -y hbase-regionserver"
        not_if { File.exists?("/etc/rc.d/init.d/hbase-regionserver") }
end

execute "start_hbaseregionserver" do
	only_if { File.exists?("/etc/rc.d/init.d/hbase-regionserver") }
        command "service hbase-regionserver start"
end

