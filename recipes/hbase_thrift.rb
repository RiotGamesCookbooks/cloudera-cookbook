package "hadoop-hbase-thrift"

# Start and enable hbase master service
service "hadoop-hbase-thrift" do
  action [ :start, :enable ]
end