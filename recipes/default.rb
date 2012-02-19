#
# Cookbook Name:: cloudera
# Recipe:: default
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

include_recipe "java"
include_recipe "cloudera::repo"

package "hadoop-#{node[:hadoop][:version]}"

directory "/var/lib/hadoop/tmpdir" do
  mode 0755
  #owner "#{node[:hadoop][:user]}"
  #group "#{node[:hadoop][:group]}"
  owner "hdfs"
  group "hdfs"
  action :create
  recursive true
end

directory "/var/lib/hadoop/mapred" do
  mode 0755
  #owner "#{node[:hadoop][:user]}"
  #group "#{node[:hadoop][:group]}"
  owner "mapred"
  group "mapred"
  action :create
  recursive true
end

directory "/etc/hadoop-#{node[:hadoop][:version]}/conf.chef" do
  mode 0750
  owner "root"
  group "root"
  action :create
  recursive true
end

# TODO  remove this shit and templitize the recipes
# Copy the riot settings over - we dont want this - move to roles via array of hashes

%w{
  core-site.xml
  fair-scheduler.xml
  hadoop-env.sh
  hadoop-metrics.properties
  hdfs-site.xml
  log4j.properties
  mapred-site.xml
}.each do |file|
  cookbook_file "/etc/hadoop-#{node[:hadoop][:version]}/conf.chef/#{file}" do
    source "conf/#{file}"
    mode 0750
    owner "hdfs"
    group "hdfs"
    action :create
  end
end

execute "update hadoop alternatives" do
  command "alternatives --install /etc/hadoop-0.20/conf hadoop-0.20-conf /etc/hadoop-0.20/conf.chef 50"
end
