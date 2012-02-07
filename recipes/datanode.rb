package "hadoop-#{node[:hadoop][:version]}-tasktracker"

service "hadoop-#{node[:hadoop][:version]}-tasktracker" do
  action [ :start, :enable ]
end
