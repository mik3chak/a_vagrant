include_recipe 'base::cloudera'

execute "install_spark_core" do
	command "yum clean all; yum install -y spark-core"
	not_if { File.exists?("/etc/default/spark") }
end

execute "install_spark_master" do
        command "yum clean all; yum install -y spark-master"
        not_if { File.exists?("/etc/rc.d/init.d/spark-master") }
end

execute "install_spark_history_server" do
        command "yum clean all; yum install -y spark-history-server"
        not_if { File.exists?("/etc/rc.d/init.d/spark-history-server") }
end

execute "install_spark_python" do
        command "yum clean all; yum install -y spark-python"
        not_if { File.exists?("/usr/bin/pyspark") }
end

script "setup_spark_in_hdfs" do
        interpreter "bash"
        code <<-EOH
                sudo -u hdfs hadoop fs -mkdir -p /user/spark
		sudo -u hdfs hadoop fs -chown -R spark:spark /user/spark
		sudo -u hdfs hadoop fs -mkdir -p /user/spark/applicationHistory
		sudo -u hdfs hadoop fs -chmod 1777 /user/spark/applicationHistory
                touch /home/vagrant/setup_spark_in_hdfs
        EOH
	notifies :run, "script[setup_applicationHistory]", :immediately
        not_if { File.exists?("/home/vagrant/setup_spark_in_hdfs") }
end

script "setup_applicationHistory" do
	interpreter "bash"
	code <<-EOH
		echo 'spark.eventLog.dir=/user/spark/applicationHistory' >> /etc/spark/conf/spark-defaults.conf
		echo 'spark.eventLog.enabled=true' >> /etc/spark/conf/spark-defaults.conf
	EOH
	action :nothing
end


execute "start_spark_master" do
	only_if { File.exists?("/etc/rc.d/init.d/spark-master") }
	command "service spark-master restart"
end

execute "start_spark_historyserver" do
	only_if { File.exists?("/etc/rc.d/init.d/spark-history-server") }
        command "service spark-history-server restart"        
end
