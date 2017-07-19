script "es_download_install" do
        cwd "/home/vagrant"
        interpreter "bash"
        code <<-EOH
	wget #{node['reposerver']}/elk/elasticsearch-#{node['es']['version']}.tar.gz
	tar xzf elasticsearch-#{node['es']['version']}.tar.gz
        EOH
end

