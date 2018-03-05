-- Extending the Base Plugin handler is optional, as there is no real
-- concept of interface in Lua, but the Base Plugin handler's methods
-- can be called from your child implementation and will print logs
-- in your `error.log` file (where all logs are printed).
local BasePlugin = require "kong.plugins.base_plugin"
local http = require 'resty.http'

local MiddlewareHandler = BasePlugin:extend()

MiddlewareHandler.PRIORITY = 1006

-- Your plugin handler's constructor. If you are extending the
-- Base Plugin handler, it's only role is to instanciate itself
-- with a name. The name is your plugin name as it will be printed in the logs.
function MiddlewareHandler:new()
  MiddlewareHandler.super.new(self, "middleware-gim")
end

function MiddlewareHandler:access(config)
  -- Eventually, execute the parent implementation
  -- (will log that your plugin is entering this context)
  MiddlewareHandler.super.access(self)

  local httpc = http:new()
  local headers = ngx.req.get_headers()
  local res, err = httpc:request_uri(config.url, {
    method = "POST",
    body = string.format("{\"ApplicationKey\": %q, \"Token\": %q}", config.appKey, headers["Token"])
  })
  if err ~= nil then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say(err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end
  if res.status > 299 then
    ngx.status = res.status
    for key, value in pairs(res.headers) do
      ngx.header[key] = value
    end
    ngx.say(res.body)
    return ngx.exit(res.status)
  end

  -- Implement any custom logic here
end

-- This module needs to return the created table, so that Kong
-- can execute those functions.
return MiddlewareHandler
