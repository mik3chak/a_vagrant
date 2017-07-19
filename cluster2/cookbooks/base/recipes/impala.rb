include_recipe 'base::cloudera'

execute "install_impala" do
	command "yum clean all; yum install -y impala impala-server impala-state-store impala-catalog impala-shell"
	not_if { File.exists?("/usr/bin/impala") }
end

script "copy_core_site.xml" do
        interpreter "bash"
        code <<-EOH
                sudo -u hdfs scp hdfs@#{ node['conf']['core-site.xml']['hostname'] }:/#{ node['conf']['core-site.xml']['path'] } /etc/impala/conf/
                touch /home/vagrant/impala_core_site
        EOH
        not_if { File.exists?("/home/vagrant/impala_core_site") }
end

script "copy_hdfs_site.xml" do
        interpreter "bash"
        code <<-EOH
		sudo -u hdfs scp hdfs@#{ node['conf']['hdfs-site.xml']['hostname'] }:
/#{ node['conf']['hdfs-site.xml']['path'] } /etc/impala/conf/
                touch /home/vagrant/impala_hdfs_site
        EOH
        not_if { File.exists?("/home/vagrant/impala_hdfs_site") }
end

script "copy_hive_site.xml" do
        interpreter "bash"
        code <<-EOH
		sudo -u hdfs scp hdfs@#{ node['conf']['hive-site.xml']['hostname'] }:
/#{ node['conf']['hive-site.xml']['path'] } /etc/impala/conf/
                touch /home/vagrant/impala_hive_site
        EOH
        not_if { File.exists?("/home/vagrant/impala_hive_site") }
end

script "copy_hbase_site.xml" do
        interpreter "bash"
        code <<-EOH
		sudo -u hdfs scp hdfs@#{ node['conf']['hbase-site.xml']['hostname'] }:/#{ node['conf']['hbase-site.xml']['path'] } /etc/impala/conf/
                touch /home/vagrant/impala_hbase_site
        EOH
        not_if { File.exists?("/home/vagrant/impala_core_site") }
end
