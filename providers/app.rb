action :create do
#  template node[:nginx][:app_configs] + "/#{new_resource.app}.conf" do
#  end

  # TODO: Should be template
  template new_resource.data_path + "/shared/config/env" do
    cookbook 'jetty'
    mode 00644
  end

  template "/engineyard/bin/app_#{new_resource.app}" do
    cookbook 'jetty'
    mode 00755
    source "app_control.erb"
    variables(
      jetty_runner: new_resource.data_path + "/shared/jetty-runner.jar",
      war: new_resource.data_path + "/shared/deploy.war",
      data_path: new_resource.data_path,
      port: new_resource.port,
    )
  end

  template "/etc/nginx/servers/#{new_resource.app}.conf" do
    cookbook 'jetty'
    mode 00644
    source "nginx.conf.erb"
    variables(
      app_name: new_resource.app,
      app_path: new_resource.data_path,
      port: new_resource.port,
    )
    notifies :restart, "service[nginx]"
  end

  cookbook_file new_resource.data_path + "/shared/jetty-runner.jar" do
    cookbook 'jetty'
    backup false
    mode 00644
  end

  # TODO: Actual deploys
  cookbook_file new_resource.data_path + "/shared/deploy.war" do
    cookbook 'jetty'
    backup false
    mode 00644
  end
end
