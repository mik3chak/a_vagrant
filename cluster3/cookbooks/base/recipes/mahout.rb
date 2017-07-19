execute "install_mahout" do
	command "yum clean all; yum install -y mahout"
	not_if { File.exists?("/usr/bin/mahout") }
end
