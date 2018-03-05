package = "kong-middleware-plugin"
version = "1.0.8-1"
source = {
   url = "https://github.com/stone-payments/kong-middleware-plugin",
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
    ["kong.plugins.kong-middleware-plugin.handler"] = "./handler.lua",
    ["kong.plugins.kong-middleware-plugin.schema"] = "./schema.lua"
   }
}
