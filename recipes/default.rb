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
  owner "hdfs"
  group "hdfs"
  action :create
  recursive true
end

directory "/var/lib/hadoop/mapred" do
  mode 0755
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

namenode = search(:node, "chef_environment:#{node.chef_environment} AND role:hadoop_namenode_server").first

core_site_vars = { :options => node[:hadoop][:core_site] }
core_site_vars[:options]['fs.default.name'] = "hdfs://#{namenode[:ipaddress]}:54310" if namenode

template "/etc/hadoop-#{node[:hadoop][:version]}/conf.chef/core-site.xml" do
  source "generic-site.xml.erb"
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables core_site_vars
end

hdfs_site_vars = { :options => node[:hadoop][:core_site] }
hdfs_site_vars[:options]['fs.default.name'] = "hdfs://#{namenode[:ipaddress]}:54310" if namenode

# TODO this template needs the secondary name node searched, key dfs.secondary.http.address
# hostname:port

template "/etc/hadoop-#{node[:hadoop][:version]}/conf.chef/hdfs-site.xml" do
  source "generic-site.xml.erb"
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables hdfs_site_vars
end

template "/etc/hadoop-#{node[:hadoop][:version]}/conf.chef/hadoop-env.sh" do
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables( :options => node[:hadoop][:hadoop_env] )
end

template "/etc/hadoop-#{node[:hadoop][:version]}/conf.chef/fair-scheduler.xml" do
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables node[:hadoop][:fair_scheduler]
end


# TODO  remove this shit and templitize the recipes
# Copy the riot settings over - we dont want this - move to roles via array of hashes
# TODO put a search for namenode in core-site.xml template

%w{
  hadoop-metrics.properties
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
