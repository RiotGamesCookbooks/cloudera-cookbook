package "hadoop-hive-server"

# Start and enable hive service
service "hadoop-hive-server" do
  action [ :start, :enable ]
end