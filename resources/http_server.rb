resource_name :nginx_http_server

actions :create
default_action :create

property :name, String, default: "default_server"
property :default_server, [true, false], default: false
property :redirect_to_https, [true, false], default: false

action_class do
  def server_conf_path
    ::File.join(sites_enabled_path, "http-" + new_resource.name + ".conf")
  end

  def sites_enabled_path
    ::File.join("", "etc", "nginx", "sites-enabled")
  end
end

action :create do
  nginx_auto_ssl_config

  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  template server_conf_path do
    source "http_server.conf.erb"

    variables(
      domain: new_resource.name,
      default_server: new_resource.default_server,
      redirect_to_https: new_resource.redirect_to_https
    )

    new_resource.notifies :restart, nginx_service, :delayed
    cookbook "nginx"
  end
end
