execute "install_oozie" do
	command "yum clean all; yum install -y oozie"
	not_if { File.exists?("/usr/bin/oozie") }
end

execute "install_oozie_client" do
        command "yum clean all; yum install -y oozie-client"
        not_if { File.exists?("/usr/bin/oozie-client") }
end

user node['user']['oozie'] do
home "/home/#{node['user']['oozie']}"
        supports :manage_home => false
        action :create
end

group node['user']['oozie'] do
        action :create
        members node['user']['oozie']
        append true
end

execute "install_mysql_connector" do
        command "yum clean all; yum install -y mysql-connector-java"
        #notifies :run, "execute[setup_mysql_connector]", :immediately
        not_if { File.exists?("/usr/share/java/mysql-connector-java.jar") }
end

execute "setup_mysql_connector" do
	only_if { File.exists?("/usr/share/java/mysql-connector-java.jar") }
        command "ln -s /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/mysql-connector-java.jar"
        action :nothing
end

template "/etc/oozie/conf/oozie-site.xml" do
        source "oozie-site.xml.erb"
end

execute "start_oozie" do
        command "service oozie restart"
end
