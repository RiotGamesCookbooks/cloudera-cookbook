package "hadoop-#{node[:hadoop][:version]}-jobtracker" do
  action :install
end

service "hadoop-#{node[:hadoop][:version]}-jobtracker" do
  action [ :start, :enable ]
end

