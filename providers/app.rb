action :create do
#  template node[:nginx][:app_configs] + "/#{new_resource.app}.conf" do
#  end
  r = []

  # TODO: Should be template
  r << template(new_resource.data_path + "/shared/config/env") do
    cookbook 'jetty'
    mode 00644
  end

  r << template("/engineyard/bin/app_#{new_resource.app}") do
    cookbook 'jetty'
    mode 00755
    source "app_control.erb"
    variables(
      jetty_runner: new_resource.data_path + "/shared/jetty-runner.jar",
      war: new_resource.data_path + "/current/deploy.war",
      data_path: new_resource.data_path,
      port: new_resource.port,
    )
  end

  r << template("/etc/nginx/servers/#{new_resource.app}.conf") do
    cookbook 'jetty'
    mode 00644
    source "nginx.conf.erb"
    variables(
      app_name: new_resource.app,
      app_path: new_resource.data_path,
      port: new_resource.port,
    )
    notifies :reload, "service[nginx]"
  end

  r << cookbook_file(new_resource.data_path + "/shared/jetty-runner.jar") do
    cookbook 'jetty'
    backup false
    mode 00644
  end

  new_resource.updated_by_last_action r.any?(&:updated_by_last_action?)
end
