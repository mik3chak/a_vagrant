node['storm']['supervisor']['nimbus'].each do |key, value|
script "update_supervisord_conf_nimbus" do
        interpreter "bash"
        code <<-EOH
        echo '#{value}' >> /etc/supervisord.conf
        EOH
end
end

node['storm']['supervisor']['ui'].each do |key, value|
script "update_supervisord_conf_ui" do
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
