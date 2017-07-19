execute "install_proxy" do
        command "yum clean all; yum install -y hadoop-yarn-proxyserver"
        not_if { File.exists?("/etc/default/hadoop-yarn-proxyserver") }
end
