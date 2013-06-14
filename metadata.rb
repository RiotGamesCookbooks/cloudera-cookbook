name             "cloudera"
maintainer       "Riot Games"
maintainer_email "cerson@me.com"
license          "Apache 2.0"
description      "Installs and configures cloudera (hadoop/hive)"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.0.1'

%w{ centos redhat fedora debian ubuntu }.each do |os|
  supports os
end

depends 'yum'
depends 'apt'

