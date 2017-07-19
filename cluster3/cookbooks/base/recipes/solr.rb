include_recipe 'base::cloudera'

execute "install_solr" do
	command "yum clean all; yum install -y solr-server"
	#notifies :run, "execute[install_mysql_connector]", :immediately
	not_if { File.exists?("/etc/default/solr") }
end

zkEnsemble = "";
node['zk']['servers'].each do |key, value|
	zkEnsemble = zkEnsemble + "#{value}:2181\\/solr,"
end
zkEnsemble = zkEnsemble.chomp(',')

script "change_settings" do
        interpreter "bash"
        code <<-EOH
	sed -i 's/SOLR_ZK_ENSEMBLE=localhost:2181\\/solr/SOLR_ZK_ENSEMBLE=#{zkEnsemble}/' /etc/default/solr
	sed -i 's/SOLR_HDFS_HOME=hdfs:\\/\\/localhost:8020\\/solr/SOLR_HDFS_HOME=hdfs:\\/\\/#{node['namenode']['hostname']}:#{node['namenode']['port']}\\/solr/' /etc/default/solr
        EOH
        only_if { File.exists?("/etc/default/solr") }
end

script "setup_solr_hdfs_directories" do
        interpreter "bash"
        code <<-EOH
		sudo -u hdfs hadoop fs -mkdir /solr
		sudo -u hdfs hadoop fs -chown solr /solr
                touch /home/vagrant/setup_hdfs_solr
        EOH
        not_if { File.exists?("/home/vagrant/setup_hdfs_solr") }
end

execute "init" do
	command "solrctl init --force"
end

execute "start_solr" do
        command "service solr-server restart"        
end

# at this point, Solr UI can be accessible from http://ip:8983
