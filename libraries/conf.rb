module Nginx
  module Conf
    def nginx_conf_path(node:)
      ::File.join(node["nginx"]["directory"], "conf.d")
    end

    def nginx_sites_enabled_path(node:)
      ::File.join(node["nginx"]["directory"], "sites-enabled")
    end

    def nginx_http_server_conf_path(name, node:)
      ::File.join(
        nginx_sites_enabled_path(node: node),
        "http-" + name + ".conf"
      )
    end

    def nginx_https_server_conf_path(name, node:)
      ::File.join(
        nginx_sites_enabled_path(node: node),
        "https-" + name + ".conf"
      )
    end

    def nginx_upstream_conf_path(name, node:)
      ::File.join(
        nginx_sites_enabled_path(node: node),
        name + ".conf"
      )
    end
  end
end
