# TODO This needs to actually use the gpg keys... derp.

case node[:platform_family]
when "rhel"

  include_recipe "yum"

  if node[:hadoop][:yum_repo_url]
    yum_repo_url = node[:hadoop][:yum_repo_url]
  else
    platform_major_version = node[:platform_version].to_i
    case platform_major_version
    when 5
      yum_repo_url = "http://archive.cloudera.com/redhat/cdh/#{node[:hadoop][:release]}"
    when 6
      yum_repo_url = "http://archive.cloudera.com/redhat/6/#{node[:kernel][:machine]}/cdh/#{node[:hadoop][:release]}"
    end
  end

  yum_repository "cloudera-cdh3" do
    name "cloudera-cdh3"
    description "Cloudera's Hadoop"
    url yum_repo_url
    action :add
  end

when "debian"

  include_recipe "apt"

  apt_repository "cloudera-cdh#{node[:hadoop][:release]}" do
    uri "http://archive.cloudera.com/debian"
    key "http://archive.cloudera.com/debian/archive.key"
#    distribution "#{node[:lsb][:codename]}-cdh#{node[:hadoop][:release]}"
    distribution "maverick-cdh#{node[:hadoop][:release]}"
    components [ "contrib" ]
    action :add
  end
end
