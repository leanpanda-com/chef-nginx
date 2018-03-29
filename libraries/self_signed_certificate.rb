def nginx_ssl_fallback_cert_path
  ::File.join(nginx_ssl_fallback_directory, "ssl-fallback.pem")
end

def nginx_ssl_fallback_key_path
  ::File.join(nginx_ssl_fallback_directory, "ssl-fallback.key")
end

def nginx_ssl_fallback_directory
  ::File.join("", "etc", "ssl")
end
