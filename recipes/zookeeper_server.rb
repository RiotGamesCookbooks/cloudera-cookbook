package "hadoop-zookeeper-server"

# Start and enable zookeeper service
service "hadoop-zookeeper-server" do
  action [ :start, :enable ]
end