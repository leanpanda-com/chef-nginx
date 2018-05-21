resource_name :nginx_config

actions :create
default_action :create

property :name, String
property :content, String

action_class do
  include Nginx::Conf
end

action :create do
  include_recipe "openresty::luarocks"

  conf_path = ::File.join(nginx_conf_path(node: node), new_resource.name + ".conf")

  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  file conf_path do
    content new_resource.content
    new_resource.notifies :restart, nginx_service, :delayed
  end
end
