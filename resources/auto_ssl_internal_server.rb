resource_name :nginx_auto_ssl_internal_server

actions :create
default_action :create

property :name, String, default: "default"

action_class do
  include Nginx::Conf
end

action :create do
  include_recipe "openresty::luarocks"

  openresty_luarock "lua-resty-auto-ssl"

  auto_ssl_internal_server_path =
    ::File.join(
      nginx_sites_enabled_path(node: node), "zzz-auto-ssl-internal.conf"
    )

  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  template auto_ssl_internal_server_path do
    source "auto-ssl-internal.conf.erb"
    new_resource.notifies :restart, nginx_service, :delayed
    cookbook "nginx"
  end
end
