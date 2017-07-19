include_recipe 'base::hbase'

execute "install_hbase" do
       command "yum clean all; yum install -y hbase"
       not_if { File.exists?("/usr/bin/hbase") }
end

template "/etc/hbase/conf/hbase-site.xml" do
       source "hbase-site.xml.erb"
end

execute "install_hbaseregionserver" do
        command "yum clean all; yum install -y hbase-regionserver"
        not_if { File.exists?("/etc/rc.d/init.d/hbase-regionserver") }
end

execute "start_hbaseregionserver" do
	#only_if { File.exists?("/etc/rc.d/init.d/hbase-regionserver") }
        command "service hbase-regionserver restart"
end

