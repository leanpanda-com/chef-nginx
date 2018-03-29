resource_name :nginx_ssl_fallback_certificate

actions :create
default_action :create

property :name, String, default: "default"

action :create do
  nginx_service = with_run_context(:root) do
    find_resource(:service, "nginx") do
      action :nothing
    end
  end

  bash "create fallback certificate" do
    code <<-EOT
      openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \\
        -subj '/CN=sni-support-required-for-valid-ssl' \\
        -keyout #{nginx_ssl_fallback_key_path} \\
        -out #{nginx_ssl_fallback_cert_path}
    EOT
    not_if do
      ::File.exist?(nginx_ssl_fallback_cert_path) &&
        ::File.exist?(nginx_ssl_fallback_key_path)
    end

    new_resource.notifies :restart, nginx_service, :delayed
  end
end
