resource_name :nginx_auto_ssl_config

actions :create
default_action :create

property :name, String, default: "default"

action_class do
  include Nginx::Conf
end

action :create do
  include_recipe "openresty::luarocks"

  openresty_luarock "lua-resty-auto-ssl"

  auto_ssl_conf_path = ::File.join(nginx_conf_path(node: node), "auto-ssl.conf")

  directory "/etc/resty-auto-ssl" do
    user node["openresty"]["user"]
    group node["openresty"]["group"]
  end

  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  template auto_ssl_conf_path do
    source "auto-ssl.conf.erb"
    new_resource.notifies :restart, nginx_service, :delayed
    cookbook "nginx"
  end
end
