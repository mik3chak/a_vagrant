execute "install_hbase_solr" do
        command "yum clean all; yum install -y hbase-solr"
        notifies :run, "execute[install_hbase_solr_indexer]", :immediately
        not_if { File.exists?("/usr/lib/hbase-solr") }
end

execute "install_hbase_solr_indexer" do
        command "yum clean all; yum install -y hbase-solr-indexer"
	notifies :run, "execute[set_env_var]", :immediately
	action :nothing
end

execute "set_env_var" do
        command "echo 'export HADOOP_CLASSPATH=/usr/lib/hbase/hbase-protocol-1.0.0-cdh5.4.2.jar' >> /home/vagrant/.bashrc"
        action :nothing
end

template "/etc/hbase-solr/conf/hbase-indexer-site.xml" do
       source "hbase-indexer-site.xml.erb"
end

execute "restart" do
        command "service hbase-solr-indexer restart"
        #action :nothing
end
