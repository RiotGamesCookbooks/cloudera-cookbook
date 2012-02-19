execute "yum makecache" do
  action :nothing
end

template "/etc/yum.repos.d/cloudera.repo" do
  owner "root"
  mode "0644"
  #source "cloudera.repo.erb"
  notifies :run, resources("execute[yum makecache]"), :immediately
end

