action :create do
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

  r << nginx_rproxy("server_#{new_resource.app}") do
    app_name new_resource.app
    data_path new_resource.data_path
    upstream_ports [new_resource.port]
    listen 81 # where does this come from in production, dna?
  end

  r << nginx_rproxy("server_#{new_resource.app}_https") do
    data_path new_resource.data_path
    upstream_ports [new_resource.port]
    listen 444
  end

  r << cookbook_file(new_resource.data_path + "/shared/jetty-runner.jar") do
    cookbook 'jetty'
    backup false
    mode 00644
  end

  new_resource.updated_by_last_action r.any?(&:updated_by_last_action?)
end
