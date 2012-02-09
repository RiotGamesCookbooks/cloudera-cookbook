package "hadoop-hbase-regionserver"

# Start and enable hbase master service
service "hadoop-hbase-regionserver" do
  action [ :start, :enable ]
end