script "es_logstash_download_install" do
        cwd "/home/vagrant"
        interpreter "bash"
        code <<-EOH
	wget #{node['reposerver']}/elk/logstash-#{node['es']['logstash']['version']}.tar.gz
	tar xzf logstash-#{node['es']['logstash']['version']}.tar.gz
        EOH
end

