#
# Cookbook Name:: cloudera
# Attributes:: default
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

default[:hadoop][:version]          = "0.20"
#default[:hadoop][:user]             = "hdfs"
#default[:hadoop][:group]            = "hdfs"
#default[:hadoop][:core_site] = Array.new
default[:hadoop][:core_site] = {
  'dfs.hosts.exclude' => '/etc/hadoop-0.20/conf.chef/exclude',
  'fs.inmemory.size.mb' => '200',
  'io.sort.factory' => '100',
  'io.sort.mb' => '200',
  'io.file.buffer.size' => '131072'
}

default[:hadoop][:hadoop_env] = {
  'hadoop_opts' => '-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false',
  'hadoop_namenode_opts' => '-Xmx4000m -Dcom.sun.management.jmxremote.port=8006',
  'hadoop_secondarynamenode_opts' => '-Dcom.sun.management.jmxremote.port=8007',
  'hadoop_datanode_opts' => '-xmx2000m -Dcom.sun.management.jmxremote.port=8008',
  'hadoop_balancer_opts' => '-dcom.sun.management.jmxremote.port=8009',
  'hadoop_jobtracker_opts' => '-xmx6000m -Dcom.sun.management.jmxremote.port=8010',
  'hadoop_tasktracker_opts' => '-xmx3000m -Dcom.sun.management.jmxremote.port=8011'
}

default[:hadoop][:config][:fair_scheduler] = {
  'pools' => {
    'hdfs' => {
      'minMaps' => '24',
      'minReduces' => '12',
      'maxMaps' => '96',
      'maxReduces' => '36',
      'maxRunningJobs' => '60',
      'minSharePreemptionTimeout' => '300',
      'weight' => '1.0'
    }
  },
  'users' => {
    'hdfs' => {
      'maxRunningJobs' => '10'
    }
  },
  'defaults' => {
    'poolMaxJobsDefault' => '20',
    'userMaxJobsDefault' => '60',
    'defaultMinSharePreemptionTimeout' => '600',
    'fairSharePreemptionTimeout' => '600'
  }
}
      




default[:java][:java_home]					= "/usr"
