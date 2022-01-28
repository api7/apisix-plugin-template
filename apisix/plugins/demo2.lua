-- local common libs
local require = require
local core    = require("apisix.core")

-- local function

-- module define
local plugin_name = "demo2"

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


function _M.access(conf, ctx)
    core.log.info("access phase")
    return 200, { message = conf.body }
end


function _M.log(conf, ctx)
    core.log.info("log phase")
end


--
return _M
