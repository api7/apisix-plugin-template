-- local common libs
local require = require
local core    = require("apisix.core")

-- local function

-- module define
local plugin_name = "demo"

-- plugin schema
local plugin_schema = {
    type = "object",
    properties = {
        body = {
            description = "body to replace response.",
            type = "string"
        },
    },
    required = {"body"},
}

local _M = {
    version  = 0.1,            -- plugin version
    priority = 0,              -- the priority of this plugin will be 0
    name     = plugin_name,    -- plugin name
    schema   = plugin_schema,  -- plugin schema
}


-- module interface for init phase
function _M.init()

end


-- module interface for schema check
-- @param `conf` user defined conf data
-- @param `schema_type` defined in `apisix/core/schema.lua`
-- @return <boolean>
function _M.check_schema(conf, schema_type)
    return core.schema.check(plugin_schema, conf)
end


-- module interface for rewrite phase
-- not actually rewrite, just before framework's access phase
function _M.rewrite()

end


-- module interface for access phase
-- @param `conf`
-- @param `ctx`
-- @return <int, object or string>
function _M.access(conf, ctx)
    return 200, { message = conf.body }
end


-- module interface for access phase
function _M.before_proxy(conf, ctx)

end


-- module interface for header_filter phase
function _M.header_filter(conf, ctx)

end


-- module interface for body_filter phase
function _M.body_filter(conf, ctx)

end


-- module interface for log phase
-- @param `conf`
-- @param `api_ctx`
function _M.log(conf, ctx)

end


local function public_api()
    return 200, {msg = "public_api"}
end


-- module interface for export public api
function _M.api()
    return {
        {
            methods = {"GET"},
            uri = "/apisix/plugin/demo/public_api",
            handler = public_api,
        }
    }
end


local function control_api()
    local args = ngx.req.get_uri_args()
    if args["json"] then
        return 200, {msg = "hello"}
    else
        return 200, "world"
    end
end


function _M.control_api()
    return {
        {
            methods = {"GET"},
            uris = {"/v1/plugin/demo/control_api"},
            handler = control_api,
        }
    }
end

--
return _M
