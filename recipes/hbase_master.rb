package "hadoop-hbase-master"

# Start and enable hbase master service
service "hadoop-hbase-master" do
  action [ :start, :enable ]
end