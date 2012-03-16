# Cloudera cookbook

Installs and configures [Cloudera's](http://www.cloudera.com/) Hadoop + Hive


# Status
Still under active development and testing. YMMV

# Requirements

* Chef 10
* Redhat, CentOS

# Attributes

## Version attributes

* `node[:hadoop][:version]` - Cloudera "sub version", cloudera provides rpms with version info in the rpm name. Default `0.20` 
* `node[:hadoop][:release]` - Cloudera release. 3u1, 3u2, etc. Used to derive url path for repo file, if you provide something different make sure the cloudera repos ([5](http://archive.cloudera.com/redhat/cdh/) & [6](http://archive.cloudera.com/redhat/6/x86_64/cdh/)) still supports that version. Default `3u3`

## Configuration attributes

* `node[:hadoop][:conf_dir]` - The hadoop config dir used inside /etc/hadoop and referenced via the alternatives system. Default `conf.chef`
* `node[:hadoop][:namenode_port]` - Port for namenode service. Default `54310`
* `node[:hadoop][:jobtracker_port]` - Port for jobtracker service. Default `54311`

##Rack-aware attributes

* `node[:hadoop][:rackaware][:datacenter]` - What datacenter is this hadoop node in. Default `default`
* `node[:hadoop][:rackaware][:rack]` - What rack is this hadoop node in. Default `rack0`

## Alternate install location attributes
* `node[:hadoop][:yum_repo_url]` - Provide an alternate yum install localtion. If you change this attribute `node[:hadoop][:release]` will not be used to derive the yum_repo_url and you are expected to provide a path to a working repo for the `node[:hadoop][:version]` used. Default `nil`
* ~~`node[:hadoop][:yum_repo_key_url]` - Provide an alternate yum repo key location. Default `nil`~~ Currently not implamented!

# License and Author

Author:: Cliff Erson (<cerson@me.com>)

Author:: Jamie Winsor (<jamie@vialstudios.com>)

Author:: Istvan Szukacs (<istvan.szukacs@gmail.com>)

Copyright 2012, Riot Games

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
