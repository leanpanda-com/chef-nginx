resource_name :nginx_https_server

actions :create
default_action :create

property :name, String, default: "default_server"
property :default_server, [true, false], default: false
property :proxies, Hash, default: {}

action_class do
  include Nginx::Conf
end

action :create do
  nginx_auto_ssl_config
  nginx_ssl_fallback_certificate
  nginx_auto_ssl_internal_server

  package "ca-certificates"

  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  https_server_path = nginx_https_server_conf_path(
    new_resource.name,
    node: node
  )

  template https_server_path do
    source "https_server.conf.erb"

    variables(
      domain: new_resource.name,
      default_server: new_resource.default_server,
      proxies: new_resource.proxies
    )

    new_resource.notifies :restart, nginx_service, :delayed
    cookbook "nginx"
  end
end
