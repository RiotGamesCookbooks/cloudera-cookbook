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

chef_conf_dir = "/etc/hadoop-#{node[:hadoop][:version]}/conf.chef"

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
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables core_site_vars
end

hdfs_site_vars = { :options => node[:hadoop][:hdfs_site] }
hdfs_site_vars[:options]['fs.default.name'] = "hdfs://#{namenode[:ipaddress]}:#{node[:hadoop][:namenode_port]}" if namenode

# TODO this template needs the secondary name node searched, key dfs.secondary.http.address format : hostname:port

template "#{chef_conf_dir}/hdfs-site.xml" do
  source "generic-site.xml.erb"
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables hdfs_site_vars
end

# TODO this template needs the job tracker searched for the below key
#default[:hadoop][:mapred_site]['mapred.job.tracker']                             = 'laxhadoop1-001:54311'

mapred_site_vars = { :options => node[:hadoop][:mapred_site] }

template "#{chef_conf_dir}/mapred-site.xml" do
  source "generic-site.xml.erb"
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables mapred_site_vars
end


template "#{chef_conf_dir}/hadoop-env.sh" do
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables( :options => node[:hadoop][:hadoop_env] )
end

template "#{chef_conf_dir}/fair-scheduler.xml" do
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables node[:hadoop][:fair_scheduler]
end

template "#{chef_conf_dir}/log4j.properties" do
  source "generic.properties.erb"
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables( :properties => node[:hadoop][:log4j] )
end

template "#{chef_conf_dir}/hadoop-metrics.properties" do
  source "generic.properties.erb"
  mode 0750
  owner "hdfs"
  group "hdfs"
  action :create
  variables( :properties => node[:hadoop][:hadoop_metrics] )
end

execute "update hadoop alternatives" do
  command "alternatives --install /etc/hadoop-0.20/conf hadoop-0.20-conf /etc/hadoop-0.20/conf.chef 50"
end
