-- local common libs
local require = require
local core    = require("apisix.core")
local ngx     = ngx

-- local function

-- module define
local plugin_sharedict = ngx.shared["demo_dict"]

local plugin_name = "demo"

-- plugin schema
local plugin_schema = {
    type = "object",
    properties = {
        msg = {
            type = "string",
        },
        ttl = {
            type = "integer",
            default = 60,
            minumum = 1,
        }
    },
    required = {"msg"},
}

local _M = {
    version  = 0.1,            -- plugin version
    priority = 0,              -- the priority of this plugin will be 0
    name     = plugin_name,    -- plugin name
    schema   = plugin_schema,  -- plugin schema
}


-- module interface for schema check
-- @param `conf` user defined conf data
-- @param `schema_type` defined in `apisix/core/schema.lua`
-- @return <boolean>
function _M.check_schema(conf, schema_type)
    return core.schema.check(plugin_schema, conf)
end


-- module interface for access phase
-- @param `conf`
-- @param `ctx`
-- @return <int, object or string>
function _M.access(conf, ctx)
    local val, err = plugin_sharedict:incr(plugin_name, 1, 0, conf.ttl)

    if err then
        core.log.error("failed to exec sharedict op, err: ", err)
        return 500, { err = err }
    end

    return 200, { message = conf.msg , count = val}
end


--
return _M
