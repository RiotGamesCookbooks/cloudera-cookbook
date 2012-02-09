package "hadoop-#{node[:hadoop][:version]}-namenode"

service "hadoop-#{node[:hadoop][:version]}-namenode" do
  action [ :start, :enable ]
end

# namenode needs /var/lib/hadoop/tmpdir/dfs/name to exist
directory "/var/lib/hadoop/tmpdir/dfs/name" do
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  recursive true
end

execute "make mapreduce dir file system" do
  command "hadoop fs -mkdir /mapred"
  creates "/mapred"
  user "hdfs"
  environment ({'JAVA_HOME' => '/usr'})
  action :run
end

execute "chown /mapred dir" do
  command "haddop fs -chown mapred /mapred"
  user "hdfs"
  environment ({'JAVA_HOME' => '/usr'})
  action :run
end
