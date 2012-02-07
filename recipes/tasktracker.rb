package "hadoop-#{node[:hadoop][:version]}-tasktracker"

# Create some data dirs. We might not need this
directory "/var/lib/hadoop/tmpdir" do
  mode 0755
  owner "hdfs"
  group "hdfs"
  action :create
  recrusive true
end

# Start data service
service "hadoop-#{node[:hadoop][:version]}-datanode" do
  action [ :start, :enable ]
end
