resource_name :nginx_http_server

actions :create
default_action :create

property :name, String, default: "default_server"
property :default_server, [true, false], default: false
property :redirect_to_https, [true, false], default: false
property :proxies, Hash, default: {}
property :extras, Array, default: []
property :logging, [true, false], default: true

action_class do
  include Nginx::Conf
end

action :create do
  include_recipe "openresty"

  nginx_default_site_symlink do
    action :delete
  end
  nginx_auto_ssl_config

  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  http_server_path = nginx_http_server_conf_path(
    new_resource.name,
    node: node
  )

  template http_server_path do
    source "http_server.conf.erb"

    variables(
      domain: new_resource.name,
      default_server: new_resource.default_server,
      redirect_to_https: new_resource.redirect_to_https,
      proxies: new_resource.proxies,
      extras: new_resource.extras,
      logging: new_resource.logging
    )

    new_resource.notifies :restart, nginx_service, :delayed
    cookbook "nginx"
  end
end
