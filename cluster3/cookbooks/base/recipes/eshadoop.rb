script "es_hadoop_download_install" do
        cwd "/home/vagrant"
        interpreter "bash"
        code <<-EOH
	wget #{node['reposerver']}/elk/elasticsearch-hadoop-#{node['es']['hadoop']['version']}.zip
	unzip elasticsearch-hadoop-#{node['es']['hadoop']['version']}.zip
        EOH
end

