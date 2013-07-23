#
# Cookbook Name:: jetty
# Recipe:: cargo
#
# Copyright 2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "jetty::default"

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

if Chef::Config[:solo]
    if node['jetty']['cargo']['password'].nil?
        Chef::Application.fatal!([ 'For chef-solo execution, you must set ',
                                   ' { ',
                                   '   "jetty": {',
                                   '     "cargo": {',
                                   '       "password": "temporarypassword"',
                                   '     }',
                                   '   }',
                                   ' }',
                                   ' in the json_attributes that are passed into chef-solo.'].join(' '))
    else
        node['jetty']['cargo']['password'] = node['jetty']['cargo']['password'].crypt('Zz')
    end
else
    node.set_unless['jetty']['cargo']['password'] = secure_password
end

template "/etc/jetty/realm.properties" do
    source "realm.properties.erb"
    variables(
        :username => node['jetty']['cargo']['username'],
        :password => node['jetty']['cargo']['password']
    )
    mode 0644
    owner "root"
    group "root"
    notifies :restart, "service[jetty]"
end


web_xml = node['jetty']['webapp_dir'] + "/cargo-jetty-#{node["jetty"]["major"]}/WEB-INF/web.xml"

cookbook_file web_xml do
    source "web.xml"
    mode 0644
    owner "jetty"
    group "jetty"
    action :nothing
    notifies :restart, "service[jetty]"
end

script "extract war" do
    interpreter "bash"
    user "jetty"
    cwd "/usr/share/jetty/webapps/"
    code <<-EOH
      mkdir cargo-jetty-#{node["jetty"]["major"]}
      cd cargo-jetty-#{node["jetty"]["major"]}
      jar xf ../#{node["jetty"]["cargo"]["war"]}
    EOH
    notifies :restart, "service[jetty]"
    action :nothing
end



remote_file "/usr/share/jetty/webapps/#{node["jetty"]["cargo"]["war"]}" do
    source node['jetty']['cargo']["jetty#{node["jetty"]["major"]}"]['source']['url']
    checksum node['jetty']['cargo']["jetty#{node["jetty"]["major"]}""]['source']['checksum']
    mode 0644
    owner "jetty"
    group "jetty"
    notifies :run, "script[extract war]", :immediately
    notifies :create, "cookbook_file[web_xml]", :immediately
    notifies :restart, "service[jetty]"
end


