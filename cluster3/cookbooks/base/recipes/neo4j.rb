execute "neo4j_download" do
	cwd "/home/vagrant"
	command "wget #{node['reposerver']}/neo4j/neo4j-#{node['neo4j']['version']}-unix.tar.gz"
	notifies :run, "execute[neo4j_install]", :immediately
	not_if {File.exists?("/home/vagrant/neo4j-#{node['neo4j']['version']}-unix.tar.gz") }
end

execute "neo4j_install" do
	cwd "/home/vagrant"
 	command "tar -xzf neo4j-#{node['neo4j']['version']}-unix.tar.gz"
	not_if { File.exists?("/home/vagrant/neo4j-#{node['neo4j']['version']}") }	
end

script "start_neo4j" do
        cwd "/home/vagrant/neo4j-#{node['neo4j']['version']}"
        interpreter "bash"
        code <<-EOH
	bin/neo4j start	
	EOH
	#action :nothing
end

#Open up your terminal/shell.
#Extract the contents of the archive, using:
#tar -xf <filecode>.
#For example,
#tar -xf neo4j-enterprise-2.3.0-unix.tar.gz 
#the top level directory is referred to as NEO4J_HOME
#Run Neo4j using,
#$NEO4J_HOME/bin/neo4j console
#Instead of ‘neo4j console’, you can use neo4j start to start the server process in the background.
#Visit http://localhost:7474 in your web browser.
#Change the password for the ‘neo4j’ account.
