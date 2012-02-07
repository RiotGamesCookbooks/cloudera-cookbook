#
# Cookbook Name:: cloudera
# Recipe:: default
#
# Copyright 2012, Riot Games Inc
#
# All rights reserved - Do Not Redistribute
include_recipe "java"

execute "yum makecache" do
  action :nothing
end

template "/etc/yum.repos.d/cloudera.repo" do
  owner "root"
  mode "0644"
  #source "cloudera.repo.erb"
  notifies :run, resources("execute[yum makecache]"), :immediately
end

package "hadoop-#{node[:hadoop][:version]}"

%w{tmpdir mapred}.each do |dir|
  directory "/var/lib/hadoop/tmpdir" do
    mode 0755
    #owner "#{node[:hadoop][:user]}"
    #group "#{node[:hadoop][:group]}"
    owner "mapred"
    group "mapred"
    action :create
    recursive true
  end
end
