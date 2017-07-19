include_recipe 'base::cloudera'

#execute "install_hbase" do
#	command "yum clean all; yum install -y hbase"
#	not_if { File.exists?("/usr/bin/hbase") }
#end
#
#template "/etc/hbase/conf/hbase-site.xml" do
#	source "hbase-site.xml.erb"
#end

script "setup_hdfs_directories" do
        interpreter "bash"
        code <<-EOH
                sudo -u hdfs hadoop fs -mkdir /hbase
		sudo -u hdfs hadoop fs -chown hbase /hbase
                touch /home/vagrant/setup_hbase_in_hdfs
        EOH
        not_if { File.exists?("/home/vagrant/setup_hbase_in_hdfs") }
	#action :nothing
end

