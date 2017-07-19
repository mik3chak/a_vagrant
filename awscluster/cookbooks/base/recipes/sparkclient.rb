include_recipe 'base::cloudera'

execute "install_spark_core" do
	command "yum clean all; yum install -y spark-core"
	not_if { File.exists?("/etc/default/spark") }
end

execute "install_spark_python" do
        command "yum clean all; yum install -y spark-python"
        not_if { File.exists?("/usr/bin/pyspark") }
end
