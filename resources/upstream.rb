resource_name :nginx_upstream

actions :create
default_action :create

action_class do
  include Nginx::Conf
end

action :create do
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
