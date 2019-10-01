default["nginx"]["user"] = "www-data"
default["nginx"]["group"] = "www-data"
default["nginx"]["directory"] = ::File.join("", "etc", "nginx")

default["nginx"]["lua-resty-auto-ssl"]["version"] = "0.13.1"
