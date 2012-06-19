#
# Cookbook Name:: cloudera
# Recipe:: hue_server
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

#This is a very explicit list what needs to be installed on the Hue server

package "hue-filebrowser-#{node[:hadoop][:hue_plugin_version]}"
package "hue-useradmin-#{node[:hadoop][:hue_plugin_version]}"
package "hue-plugins-#{node[:hadoop][:hue_plugin_version]}"
package "hue-help-#{node[:hadoop][:hue_plugin_version]}"
package "hue-jobbrowser-#{node[:hadoop][:hue_plugin_version]}"
package "hue-about-#{node[:hadoop][:hue_plugin_version]}"
package "hue-beeswax-#{node[:hadoop][:hue_plugin_version]}"
package "hue-proxy-#{node[:hadoop][:hue_plugin_version]}"
package "hue-#{node[:hadoop][:hue_plugin_version]}"
package "hue-common-#{node[:hadoop][:hue_plugin_version]}"
package "hue-jobsub-#{node[:hadoop][:hue_plugin_version]}"
package "hue-shell-#{node[:hadoop][:hue_plugin_version]}"


template "/etc/hue/hue.ini" do
  mode 0755
  owner "root"
  group "root"
end


service "hue" do
  action [ :start, :enable ]
end
