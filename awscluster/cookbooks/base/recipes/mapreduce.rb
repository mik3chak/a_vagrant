include_recipe 'base::cloudera'

execute "install_MR" do
        command "yum clean all; yum install -y hadoop-mapreduce"
	not_if { File.exists?("/usr/lib/hadoop-mapreduce") }
end
