package = "kong-authentication-plugin"
version = "0.0.0-2"
source = {
   url = "https://github.com/PFadel/kong-authentication-plugin",
}
description = {
  summary = "A Kong plugin that enables services to act as middlewares for requests",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1",
  "lua-resty-http"
}
build = {
   type = "builtin",
   modules = {
    ["kong.plugins.kong-authentication-plugin.handler"] = "./handler.lua",
    ["kong.plugins.kong-authentication-plugin.schema"] = "./schema.lua"
   }
}
