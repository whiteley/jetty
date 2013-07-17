include_recipe 'java'
include_recipe 'nginx'

jetty_tmp_path = "/tmp/" + File.basename(node["jetty"]["deb_url"])

remote_file "jetty" do
  path jetty_tmp_path
  source node["jetty"]["deb_url"]

  not_if "dpkg-query -S jetty"
  notifies :install, "package[jetty]", :immediately
end

package "jetty" do
  action :nothing
  source jetty_tmp_path
end
