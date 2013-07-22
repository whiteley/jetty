
case node["platform"]
when "debian", "ubuntu"
  apt_repository "ey-jetty" do
    uri "http://jdk-debs.s3.amazonaws.com"
    distribution node["lsb"]["codename"]
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "782200EA"
  end

  node.normal["jetty"]["packages"] = ["jetty-hightide-server"]

  node.normal["jetty"]["user"] = "deploy"
  node.normal["jetty"]["group"] = "deploy"

  node.normal["jetty"]["home"] = "/opt/jetty"
  node.normal["jetty"]["config_dir"] = "/opt/jetty/etc"
  node.normal["jetty"]["context_dir"] = "/opt/jetty/contexts"
  node.normal["jetty"]["log_dir"] = "/opt/jetty/logs"
  node.normal["jetty"]["webapp_dir"] = "/opt/jetty/webapps"

else
  Chef::Application.fatal! "ey_jetty not implemented for #{node['platform']} yet"
end

directory node["jetty"]["tmp_dir"] do
  recursive true
  mode 00644
  owner node["jetty"]["user"]
  group node["jetty"]["group"]
end

include_recipe "java"
include_recipe "nginx"
include_recipe "jetty"
