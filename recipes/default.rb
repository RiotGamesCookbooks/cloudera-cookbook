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

chef_conf_dir = "/etc/hadoop-#{node[:hadoop][:version]}/#{node[:hadoop][:conf_dir]}"

package "hadoop-#{node[:hadoop][:version]}"

# Create some hadoop needed? dirs 
# TODO abstract those 2 dirs to attributes
# TODO might not need these
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

directory chef_conf_dir do
  mode 0755
  owner "root"
  group "root"
  action :create
  recursive true
end

namenode = search(:node, "chef_environment:#{node.chef_environment} AND role:hadoop_namenode_server").first

core_site_vars = { :options => node[:hadoop][:core_site] }
core_site_vars[:options]['fs.default.name'] = "hdfs://#{namenode[:ipaddress]}:#{node[:hadoop][:namenode_port]}" if namenode

template "#{chef_conf_dir}/core-site.xml" do
  source "generic-site.xml.erb"
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  variables core_site_vars
end

secondary_namenode = search(:node, "chef_environment:#{node.chef_environment} and role:hadoop_secondary_namenode_server").first

hdfs_site_vars = { :options => node[:hadoop][:hdfs_site] }
hdfs_site_vars[:options]['fs.default.name'] = "hdfs://#{namenode[:ipaddress]}:#{node[:hadoop][:namenode_port]}" if namenode
# TODO dfs.secondary.http.address should have port made into an attribute - maybe
hdfs_site_vars[:options]['dfs.secondary.http.address'] = "#{secondary_namenode[:ipaddress]}:50090" if secondary_namenode

template "#{chef_conf_dir}/hdfs-site.xml" do
  source "generic-site.xml.erb"
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  variables hdfs_site_vars
end

jobtracker = search(:node, "chef_environment:#{node.chef_environment} AND role:hadoop_jobtracker_server").first

mapred_site_vars = { :options => node[:hadoop][:mapred_site] }
mapred_site_vars[:options]['mapred.job.tracker'] = "#{jobtracker[:ipaddress]}:#{node[:hadoop][:jobtracker_port]}" if jobtracker

template "#{chef_conf_dir}/mapred-site.xml" do
  source "generic-site.xml.erb"
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  variables mapred_site_vars
end


template "#{chef_conf_dir}/hadoop-env.sh" do
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  variables( :options => node[:hadoop][:hadoop_env] )
end

template node[:hadoop][:mapred_site]['mapred.fairscheduler.allocation.file'] do
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  variables node[:hadoop][:fair_scheduler]
end

template "#{chef_conf_dir}/log4j.properties" do
  source "generic.properties.erb"
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  variables( :properties => node[:hadoop][:log4j] )
end

template "#{chef_conf_dir}/hadoop-metrics.properties" do
  source "generic.properties.erb"
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  variables( :properties => node[:hadoop][:hadoop_metrics] )
end

# create the topology.script.file.name dir
toplogy_dir = File.dirname(node[:hadoop][:hdfs_site]['topology.script.file.name'])
# TODO create the topoloy template

directory toplogy_dir do
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  recursive true
end

execute "update hadoop alternatives" do
  command "alternatives --install /etc/hadoop-#{node[:hadoop][:version]}/conf hadoop-#{node[:hadoop][:version]}-conf /etc/hadoop-#{node[:hadoop][:version]}/#{node[:hadoop][:conf_dir]} 50"
end
