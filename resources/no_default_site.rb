resource_name :nginx_default_site_symlink

actions :delete
default_action :delete

property :name, String, default: "default"

action :delete do
  include_recipe "openresty"

  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  sites_enabled = ::File.join("", "etc", "nginx", "sites-enabled")
  sites_enabled_default = ::File.join(sites_enabled, new_resource.name)

  file sites_enabled_default do
    action :delete
    notifies :reload, "service[nginx]", :immediately
  end
end
