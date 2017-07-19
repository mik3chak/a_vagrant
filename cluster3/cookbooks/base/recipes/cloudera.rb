directory "/etc/yum.repos.d/bk" do
	action :create
	not_if { File.exists?("/etc/yum.repos.d/bk") }
end

execute "backup_repos" do
	only_if { File.exists?("/etc/yum.repos.d/bk") }
	cwd '/etc/yum.repos.d/'
	command "mv *.repo bk/"
end

template "/etc/yum.repos.d/cloudera-cdh5.repo" do
        source "default.conf.erb"
        owner "root"
        mode "0644"
        not_if { File.exists?("/etc/yum.repos.d/cloudera-cdh5.repo") }
end

template "/etc/yum.repos.d/mysql.repo" do
        source "mysql.repo.erb"
        owner "root"
        mode "0644"
        not_if { File.exists?("/etc/yum.repos.d/mysql.repo") }
	#action :nothing
end

template "/etc/yum.repos.d/misc.repo" do
        source "misc.repo.erb"
        owner "root"
        mode "0644"
        not_if { File.exists?("/etc/yum.repos.d/misc.repo") }
        #action :nothing
end
