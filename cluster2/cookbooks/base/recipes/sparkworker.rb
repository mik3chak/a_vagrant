include_recipe 'base::cloudera'

execute "install_spark_core" do
	command "yum clean all; yum install -y spark-core"
	not_if { File.exists?("/etc/default/spark") }
end

execute "install_spark_worker" do
        command "yum clean all; yum install -y spark-worker"
        not_if { File.exists?("/etc/rc.d/init.d/spark-worker") }
end

execute "install_spark_python" do
        command "yum clean all; yum install -y spark-python"
        not_if { File.exists?("/usr/bin/pyspark") }
end

execute "start_spark_worker" do
	only_if { File.exists?("/etc/rc.d/init.d/spark-worker") }
	command "service spark-worker restart"
end
