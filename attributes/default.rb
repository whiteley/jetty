#
# Cookbook Name:: jetty
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
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

default["jetty"]["host"] = "0.0.0.0"
default["jetty"]["port"] = 8080
default["jetty"]["no_start"] = 0
default["jetty"]["jetty_args"] = ""
default["jetty"]["java_options"] = "-Xmx256m -Djava.awt.headless=true"
default["jetty"]["cargo"]["username"] = "cargo"
default["jetty"]["cargo"]["jetty6"]["source"]["url"] = "http://repo1.maven.org/maven2/org/codehaus/cargo/cargo-jetty-6-and-earlier-deployer/1.2.2/cargo-jetty-6-and-earlier-deployer-1.2.2.war"
default["jetty"]["cargo"]["jetty8"]["source"]["url"] = "http://repo1.maven.org/maven2/org/codehaus/cargo/cargo-jetty-7-and-onwards-deployer/1.4.3/cargo-jetty-7-and-onwards-deployer-1.4.3.war"
default["jetty"]["cargo"]["jetty6"]["source"]["checksum"] = "34ea6285c48c31e579aee69ba138cf94015070aacafc1a993f37a9e6534fe064"
default["jetty"]["cargo"]["jetty8"]["source"]["checksum"] = "2e46c009954d469606381d1d74c7c917f47b05afcfbc68b0dae4fb38bee92832"

case platform
when "centos","redhat","fedora","amazon","scientific"
  default["jetty"]["major"] = "6"
  default["jetty"]["packages"] = ["jetty6","jetty6-jsp-2.1","jetty6-management"]

  default["jetty"]["user"] = "root"
  default["jetty"]["group"] = "root"
  default["jetty"]["home"] = "/usr/share/jetty6"
  default["jetty"]["config_dir"] = "/etc/jetty6"
  default["jetty"]["log_dir"] = "/var/log/jetty6"
  default["jetty"]["tmp_dir"] = "/var/cache/jetty/data"
  default["jetty"]["context_dir"] = "/srv/jetty6/contexts"
  default["jetty"]["webapp_dir"] = "/srv/jetty6/webapps"
when "debian","ubuntu"
  default["jetty"]["major"] = "8"
  default["jetty"]["packages"] = ["jetty","libjetty-extra"]

  default["jetty"]["user"] = "jetty"
  default["jetty"]["group"] = "jetty"
  default["jetty"]["home"] = "/usr/share/jetty"
  default["jetty"]["config_dir"] = "/etc/jetty"
  default["jetty"]["log_dir"] = "/var/log/jetty"
  default["jetty"]["tmp_dir"] = "/var/cache/jetty/data"
  default["jetty"]["context_dir"] = "/etc/jetty/contexts"
  default["jetty"]["webapp_dir"] = "/var/lib/jetty/webapps"
else
  default["jetty"]["major"] = "8"
  default["jetty"]["packages"] = ["jetty"]

  default["jetty"]["user"] = "jetty"
  default["jetty"]["group"] = "jetty"
  default["jetty"]["home"] = "/usr/share/jetty"
  default["jetty"]["config_dir"] = "/etc/jetty"
  default["jetty"]["log_dir"] = "/var/log/jetty"
  default["jetty"]["tmp_dir"] = "/var/cache/jetty/data"
  default["jetty"]["context_dir"] = "/etc/jetty/contexts"
  default["jetty"]["webapp_dir"] = "/var/lib/jetty/webapps"
end

default["jetty"]["cargo"]["war"] = node["jetty"]["cargo"]["jetty#{node["jetty"]["major"]}"]["source"]["url"].split('/').last
