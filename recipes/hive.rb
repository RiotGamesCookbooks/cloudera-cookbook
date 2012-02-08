package "hadoop-#{node[:hadoop][:version]}-hive"

# Start hive service
service "hadoop-#{node[:hadoop][:version]}-hive" do
  action [ :start, :enable ]
end
