package "hadoop-hive-metastore"

# Start and enable hive metastore service
service "hadoop-hive-metastore" do
  action [ :start, :enable ]
end