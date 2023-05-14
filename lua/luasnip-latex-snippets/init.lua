#!/bin/lua
require("luasnip").log.set_loglevel("info")
require("luasnip.loaders.from_lua").load({paths = debug.getinfo(1).source:sub(2) .. "luasnippets"})

-- info = debug.getinfo(1, "Sl")
-- print(info.source:sub(2))
