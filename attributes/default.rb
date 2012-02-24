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

default[:hadoop][:hadoop_env][:hadoop_opts]                   = '-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false'
default[:hadoop][:hadoop_env][:hadoop_namenode_opts]          = '-Xmx4000m -Dcom.sun.management.jmxremote.port=8006'
default[:hadoop][:hadoop_env][:hadoop_secondarynamenode_opts] = '-Dcom.sun.management.jmxremote.port=8007'
default[:hadoop][:hadoop_env][:hadoop_datanode_opts]          = '-xmx2000m -Dcom.sun.management.jmxremote.port=8008'
default[:hadoop][:hadoop_env][:hadoop_balancer_opts]          = '-dcom.sun.management.jmxremote.port=8009'
default[:hadoop][:hadoop_env][:hadoop_jobtracker_opts]        = '-xmx6000m -Dcom.sun.management.jmxremote.port=8010'
default[:hadoop][:hadoop_env][:hadoop_tasktracker_opts]       = '-xmx3000m -Dcom.sun.management.jmxremote.port=8011'

default[:hadoop][:version]                                                      = "0.20"
#default[:hadoop][:user]             = "hdfs"
#default[:hadoop][:group]            = "hdfs"

default[:hadoop][:core_site]['dfs_hosts_exclude']                                = '/etc/hadoop-0.20/conf.chef/exclude'
default[:hadoop][:core_site]['fs_inmemory_size_mb']                              = 200
default[:hadoop][:core_site]['io_sort_factory']                                  = 100
default[:hadoop][:core_site]['io_sort_mb']                                       = 200
default[:hadoop][:core_site]['io_file_buffer_size']                              = 131072

default[:hadoop][:fair_scheduler][:pools][:hdfs][:minMaps]                      = 24
default[:hadoop][:fair_scheduler][:pools][:hdfs][:minReduces]                   = 12
default[:hadoop][:fair_scheduler][:pools][:hdfs][:maxMaps]                      = 96
default[:hadoop][:fair_scheduler][:pools][:hdfs][:maxReduces]                   = 36
default[:hadoop][:fair_scheduler][:pools][:hdfs][:maxRunningJobs]               = 60
default[:hadoop][:fair_scheduler][:pools][:hdfs][:minSharePreemptionTimeout]    = 300
default[:hadoop][:fair_scheduler][:pools][:hdfs][:weight]                       = "1.0"

default[:hadoop][:fair_scheduler][:users][:hdfs][:maxRunningJobs] = 10

default[:hadoop][:fair_scheduler][:defaults][:poolMaxJobsDefault]               = 20
default[:hadoop][:fair_scheduler][:defaults][:userMaxJobsDefault]               = 20
default[:hadoop][:fair_scheduler][:defaults][:defaultMinSharePreemptionTimeout] = 600
default[:hadoop][:fair_scheduler][:defaults][:fairSharePreemptionTimeout]       = 600

default[:hadoop][:hdfs_site]['dfs.replication']                                 = 3
default[:hadoop][:hdfs_site]['dfs.name.dir']                                    = '/var/lib/hadoop/tmpdir/dfs/name'
default[:hadoop][:hdfs_site]['dfs.data.dir']                                    = '/hdfs1,/hdfs2,/hdfs3,/hdfs4'
default[:hadoop][:hdfs_site]['topology.script.file.name']                       = '/home/hdfs/rackawareNamenodeConfig/topology.py'
default[:hadoop][:hdfs_site]['fs.trash.interval']                               = 1440

default[:java][:java_home]					                                            = "/usr"
