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
