#!/bin/lua
require("luasnip.loaders.from_lua").load(debug.getinfo(1, "Sl").source:sub(2) .. "luasnippets") 

-- info = debug.getinfo(1, "Sl")
-- print(info.source:sub(2))
