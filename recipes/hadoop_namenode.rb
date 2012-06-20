#
# Cookbook Name:: cloudera
# Recipe:: hadoop_namenode
#
# Author:: Cliff Erson (<cerson@me.com>)
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

include_recipe "cloudera"

package "hadoop-#{node[:hadoop][:version]}-namenode"

template "/usr/lib/hadoop-#{node[:hadoop][:version]}/bin/hadoop-config.sh" do
  source "hadoop_config.erb"
  mode 0755
  owner "root"
  group "root"
  variables(
    :java_home => node[:java][:java_home]
  )
end

template "/etc/init.d/hadoop-#{node[:hadoop][:version]}-namenode" do
  mode 0755
  owner "root"
  group "root"
  variables(
    :java_home => node[:java][:java_home]
  )
end

directory node[:hadoop][:hdfs_site]['dfs.name.dir'] do
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  recursive true
end

service "hadoop-#{node[:hadoop][:version]}-namenode" do
  action [ :start, :enable ]
end

execute "make mapreduce dir file system" do
  command "hadoop fs -mkdir /mapred"
  user "hdfs"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
  not_if "hadoop fs -test -d /mapred"
end

execute "chown /mapred dir" do
  command "hadoop fs -chown mapred /mapred"
  user "hdfs"
  environment ({'JAVA_HOME' => node[:java][:java_home]})
  action :run
end
