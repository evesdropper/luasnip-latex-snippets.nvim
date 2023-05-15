#!/bin/lua
local ls = require("luasnip")
ls.log.ping()
ls.log.set_loglevel("debug")
vim.pretty_print(debug.getinfo(1).source:sub(2):gsub("init.lua", ""))
require("luasnip.loaders.from_lua").load({paths = debug.getinfo(1).source:sub(2):gsub("init.lua", "") .. "luasnippets"})

-- info = debug.getinfo(1, "Sl")
-- print(info.source:sub(2))
