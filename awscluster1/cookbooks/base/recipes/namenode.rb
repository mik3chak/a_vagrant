include_recipe 'base::cloudera'

user node['user']['hdfs'] do
home "/home/#{node['user']['hdfs']}"
	supports :manage_home => true	
	action :create
end

user node['user']['yarn'] do
home "/home/#{node['user']['yarn']}"
	supports :manage_home => false	
	action :create
end

group node['user']['hdfs'] do
	action :create
	members node['user']['hdfs']
	append true
end

group node['user']['yarn'] do
	action :create
	members node['user']['yarn']
	append true
end

directory "/data" do
	owner node['user']['hdfs']
        group node['user']['hdfs']
        mode '0700'
        action :create
        not_if { File.exists?("/data") }
end

%w{ 1 nfsmount }.each do |nn|
	directory "/data/#{nn}" do
		owner node['user']['hdfs']
	        group node['user']['hdfs']
        	mode '0700'
		action :create	        
        	not_if { File.exists?("/data/#{nn}") }
	end
	directory "/data/#{nn}/dfs" do
                owner node['user']['hdfs']
                group node['user']['hdfs']
                mode '0700'
                action :create          
                not_if { File.exists?("/data/#{nn}/dfs") }
        end
	directory "/data/#{nn}/dfs/nn" do
                owner node['user']['hdfs']
                group node['user']['hdfs']
                mode '0700'
                action :create          
                not_if { File.exists?("/data/#{nn}/dfs/nn") }
        end
end

#%w{ 1 nfsmount }.each do |nn|
#directory "/data/#{nn}/dfs/nn" do
#        owner node['user']['hdfs']
#        group node['user']['hdfs']
#        mode '0700'
#        action :create
#        recursive true
#        not_if { File.exists?("/data/#{nn}/dfs/nn") }
#        #action :nothing
#end
#end

execute "install_NN" do
        command "yum clean all; yum install -y hadoop-hdfs-namenode"
	#action :nothing
	notifies :run, "execute[install_client]", :immediately
	not_if { File.exists?("/etc/default/hadoop-hdfs-namenode") }
end

execute "install_client" do
        command "yum clean all; yum install -y hadoop-client"
	action :nothing
	notifies :run, "execute[install_done]", :immediately
	not_if { File.exists?("/usr/lib/hadoop/client") }
end

execute "install_done" do
        command "touch /home/vagrant/install_done"
        action :nothing
end

template "/etc/hadoop/conf/core-site.xml" do
        source "core-site.xml.erb"
end

template "/etc/hadoop/conf/hdfs-site.xml" do
        source "hdfs-site.xml.erb"
end

template "/etc/hadoop/conf/masters" do
	only_if { node['namenode']['hostname'] != node['secondarynamenode']['hostname'] }
	source "masters.erb"
	not_if { File.exists?("/etc/hadoop/conf/masters") }
end

execute "format" do
	user node['user']['hdfs']
	group node['user']['hdfs']
        only_if { File.exists?("/home/vagrant/install_done") }
        #command "sudo -u hdfs hdfs namenode -format -force -nonInteractive"
	command "hdfs namenode -format -force -nonInteractive"
	#command "sudo su - #{node['user']['hdfs']} -c 'hdfs namenode -format -force -nonInteractive'"
        notifies :run, "execute[post-format]", :immediately
        not_if { File.exists?("/home/vagrant/formatted") }
end

execute "post-format" do
        command "touch /home/vagrant/formatted"
	notifies :run, "execute[start_NN]", :immediately
        action :nothing
end

execute "start_NN" do
command "service hadoop-hdfs-namenode start"	
	action :nothing
end

script "setup_hdfs_directories" do
        only_if { File.exists?("/home/vagrant/formatted") }
        interpreter "bash"
        code <<-EOH
                sudo -u hdfs hadoop fs -mkdir /tmp
		sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
                sudo -u hdfs hadoop fs -mkdir -p /user/history
                sudo -u hdfs hadoop fs -chmod -R 1777 /user/history
                sudo -u hdfs hadoop fs -chown mapred:hadoop /user/history
                sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
                sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn
		sudo -u hdfs hadoop fs -mkdir /user/hdfs
		sudo -u hdfs hadoop fs -chown hdfs /user/hdfs
                touch /home/vagrant/setup_hdfs
        EOH
        not_if { File.exists?("/home/vagrant/setup_hdfs") }
end

#execute "install_history" do
#        command "yum clean all; yum install -y hadoop-mapreduce-historyserver"
#	notifies :run, "execute[start_MRHS]", :immediately
#	not_if { File.exists?("/etc/default/hadoop-mapreduce-historyserver") }
#end
#
#execute "start_MRHS" do
#        command "service hadoop-mapreduce-historyserver start"
#	action :nothing
#end
#
#execute "install_proxy" do
#        command "yum clean all; yum install -y hadoop-yarn-proxyserver"
#        not_if { File.exists?("/etc/default/hadoop-yarn-proxyserver") }
#end
