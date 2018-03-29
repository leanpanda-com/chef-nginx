module Nginx
  module Conf
    def nginx_base_path(node:)
      ::File.join(node["nginx"]["directory"] || ::File.join("", "env", "nginx"))
    end

    def nginx_conf_path(node:)
      ::File.join(nginx_base_path(node: node), "conf.d")
    end

    def nginx_enabled_path(node:)
      ::File.join(nginx_base_path(node: node), "sites-enabled")
    end
  end
end
