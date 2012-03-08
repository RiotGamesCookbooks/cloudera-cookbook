#
# Cookbook Name:: cloudera
# Recipe:: hadoop_namenode
#
# Author:: Cliff Erson (<cerson@me.com>)
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

# TODO http://hadoop-karma.blogspot.com/2011/01/hadoop-cookbook-how-to-configure-hadoop.html
# Turns out this dfs.name.dir can have many dirs split on , - figure this out
# This should also notify an execute for 'hadooop namenode -format' 
# currently Im not sure how to force Y into the above command as it requires interaction.
# Also you cna only format namenode once unless you want to whipe  your metadata 
# so this directory needs a check to make sure its just not creating it again and again and triggering the notify
directory node[:hadoop][:hdfs_site]['dfs.name.dir'] do
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  recursive true
  #notify the hadoop namenode format execute
end

service "hadoop-#{node[:hadoop][:version]}-namenode" do
  action [ :start, :enable ]
end

execute "make mapreduce dir file system" do
  command "hadoop fs -mkdir /mapred"
  user "hdfs"
  environment ({'JAVA_HOME' => node[:java][:java_home]}) # TODO this should not be hard coded
  action :run
  not_if "hadoop fs -test -d /mapred"
end

execute "chown /mapred dir" do
  command "hadoop fs -chown mapred /mapred"
  user "hdfs"
  environment ({'JAVA_HOME' => node[:java][:java_home]}) # TODO this should not be hard coded
  action :run
end
