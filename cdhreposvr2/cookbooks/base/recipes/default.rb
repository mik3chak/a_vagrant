execute "install" do
	command "yum install -y yum-utils createrepo lighttpd"
	notifies :run, "script[post_install]", :immediately
	not_if { File.exists?("/etc/lighttpd/lighttpd.conf") }
end

script "post_install" do
	interpreter "bash"
	code <<-EOH
		chkconfig --levels 235 lighttpd on
		service lighttpd start
	EOH
	action :nothing        
end

directory '/var/www/lighttpd/cdh/5.4.2/RPMS/noarch' do
	#owner 'vagrant'
	#group 'vagrant'
	mode '0755'
	action :create
	recursive true
	not_if { File.exists?("/var/www/lighttpd/cdh/5.4.2/RPMS/noarch") }
end

directory '/var/www/lighttpd/cdh/5.4.2/RPMS/x86_64' do
	#owner 'vagrant'
	#group 'vagrant'
	mode '0755'
	action :create
	recursive true
	not_if { File.exists?("/var/www/lighttpd/cdh/5.4.2/RPMS/x86_64") }
end

# do manual download/copy from local host due to large amount of files

template "/etc/yum.repos.d/cloudera-cdh5.repo" do
	source "default.conf.erb"
	owner "root"
	mode "0644"
	#notifies :run, "script[yum_operation]", :immediately
	not_if { File.exists?("/etc/yum.repos.d/cloudera-cdh5.repo") }
end

execute "install2" do
        command "yum install -y yum-plugin-downloadonly"
        #notifies :run, "execute[post_install2]", :immediately
	notifies :run, "script[download_all]", :immediately
end

#execute "post_install2" do
#        command "yum install -y --downloadonly --downloaddir=/home/vagrant zookeeper-server"
#end

script "download_all" do
	interpreter "bash"
	code <<-EOH
		yum install -y --downloadonly --downloaddir=/home/vagrant zookeeper-server
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-hdfs-namenode
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-hdfs-datanode
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-hdfs-secondarynamenode
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-mapreduce
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-mapreduce-historyserver
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-yarn-proxyserver
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-yarn-resourcemanager
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-yarn-nodemanager	
		yum install -y --downloadonly --downloaddir=/home/vagrant hadoop-client

		yum install -y --downloadonly --downloaddir=/home/vagrant hive
                yum install -y --downloadonly --downloaddir=/home/vagrant hive-server2

		yum install -y --downloadonly --downloaddir=/home/vagrant sentry

		yum install -y --downloadonly --downloaddir=/home/vagrant solr

		yum install -y --downloadonly --downloaddir=/home/vagrant flume-ng
		yum install -y --downloadonly --downloaddir=/home/vagrant flume-ng-agent
	
		yum install -y --downloadonly --downloaddir=/home/vagrant pig	

		yum install -y --downloadonly --downloaddir=/home/vagrant hbase
		yum install -y --downloadonly --downloaddir=/home/vagrant hbase-master
		yum install -y --downloadonly --downloaddir=/home/vagrant hbase-regionserver

		yum install -y --downloadonly --downloaddir=/home/vagrant spark-core
		yum install -y --downloadonly --downloaddir=/home/vagrant spark-master
		yum install -y --downloadonly --downloaddir=/home/vagrant spark-worker
		yum install -y --downloadonly --downloaddir=/home/vagrant spark-history-server
		yum install -y --downloadonly --downloaddir=/home/vagrant spark-python

		yum install -y --downloadonly --downloaddir=/home/vagrant oozie
		yum install -y --downloadonly --downloaddir=/home/vagrant oozie-client

		yum install -y --downloadonly --downloaddir=/home/vagrant sqoop2-server
		yum install -y --downloadonly --downloaddir=/home/vagrant sqoop2-client

		yum install -y --downloadonly --downloaddir=/home/vagrant impala
		yum install -y --downloadonly --downloaddir=/home/vagrant impala-server
		yum install -y --downloadonly --downloaddir=/home/vagrant impala-state-store
		yum install -y --downloadonly --downloaddir=/home/vagrant impala-catalog
		yum install -y --downloadonly --downloaddir=/home/vagrant impala-shell

		yum install -y --downloadonly --downloaddir=/home/vagrant hue

	EOH
	action :nothing

# do manual download/copy from local host due to large amount of files

#script "yum_operation" do
#	cwd '/var/www/lighttpd/cdh/5.4.2'
#	interpreter "bash"
#	code <<-EOH
#		createrepo .
#		yum makecache
#	EOH
#	not_if { File.exists?("/var/www/lighttpd/cdh/5.4.2/repodata") }
#end
