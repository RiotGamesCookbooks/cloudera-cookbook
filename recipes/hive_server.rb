#
# Cookbook Name:: cloudera
# Recipe:: hive_server
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

package "hadoop-hive-server"

case node[:platform_family]
when "rhel"
  template "/etc/init.d/hadoop-hive-server" do
    source "hadoop_hive_server.erb"
    mode 0755
    owner "root"
    group "root"
    variables(
      :java_home => node[:java][:java_home]
    )
  end
end

hive_env_vars = { :options => node[:hive][:hive_env_options] }

template "/etc/hive/conf/hive-env.sh" do
  source "hive-env.sh.erb"
  mode 0644
  owner "root"
  group "root"
  action :create
  variables hive_env_vars
end


service "hadoop-hive-server" do
  action [ :start, :enable ]
end
