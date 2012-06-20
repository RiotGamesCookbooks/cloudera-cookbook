#
# Cookbook Name:: cloudera
# Recipe:: hive
#
# Author:: Istvan Szukacs (<istvan.szukacs@gmail.com>)
# Copyright 2012, Riot Games
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
#

include_recipe "cloudera::repo"

package "mysql-connector-java"
package "hadoop-hive"
package "hadoop-#{node[:hadoop][:version]}-native"

execute "copy_connector" do
  command "cp /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/mysql-connector-java.jar"
end

hive_site_vars = { :options => node[:hive][:hive_site_options] }

template "/etc/hive/conf/hive-site.xml" do
  source "generic-site.xml.erb"
  mode 0644
  owner "root"
  group "root"
  action :create
  variables hive_site_vars
end
