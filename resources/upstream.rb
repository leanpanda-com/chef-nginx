resource_name :nginx_upstream

actions :create
default_action :create

property :name, String, name_property: true
property :port, [Integer, String]

action_class do
  include Nginx::Conf
end

action :create do
  include_recipe "openresty"

  upstream_file_path = nginx_upstream_conf_path(new_resource.name, node: node)

  template upstream_file_path do
    source "upstream.conf.erb"
    cookbook "nginx"
    variables(
      name: new_resource.name,
      port: new_resource.port
    )
  end
end
