resource_name :nginx_ip_responder

actions :create
default_action :create

property :name, String, default: "ip_responder"

action_class do
  include Nginx::Conf
end

action :create do
  include_recipe "openresty"

  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  conf_path = ::File.join(
    nginx_sites_enabled_path(node: node),
    "ip_responder.conf"
  )

  template conf_path do
    source "ip_responder.conf.erb"

    new_resource.notifies :restart, nginx_service, :delayed
    cookbook "nginx"
  end
end
