node['storm']['supervisor']['slave'].each do |key, value|
script "update_supervisord_conf_slave" do
        interpreter "bash"
        code <<-EOH
        echo '#{value}' >> /etc/supervisord.conf
        EOH
end
end

execute "start_supervisord" do
	command "service supervisord restart"
end

# if fine, http://192.168.56.207:8080
