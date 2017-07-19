execute "install_history" do
        command "yum clean all; yum install -y hadoop-mapreduce-historyserver"
        notifies :run, "execute[start_MRHS]", :immediately
        not_if { File.exists?("/etc/default/hadoop-mapreduce-historyserver") }
end

execute "start_MRHS" do
        command "service hadoop-mapreduce-historyserver start"
        action :nothing
end

