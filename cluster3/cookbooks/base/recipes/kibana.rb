script "es_kibana_download_install" do
        cwd "/home/vagrant"
        interpreter "bash"
        code <<-EOH
	wget #{node['reposerver']}/elk/kibana-#{node['es']['kibana']['version']}-linux-x64.tar.gz
	tar xzf kibana-#{node['es']['kibana']['version']}-linux-x64.tar.gz
        EOH
end

