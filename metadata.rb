name             "jetty"
maintainer       "Engine Yard"
maintainer_email "cookbooks@engineyard.com"
license          "All rights reserved"
description      "Provides jetty appserver resource"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

supports "ubuntu"

depends "java"
depends "jetty"
depends "nginx"
