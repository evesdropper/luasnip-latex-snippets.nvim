#!/bin/lua
-- local ls = require("luasnip")
-- ls.log.ping()
-- ls.log.set_loglevel("debug")
-- vim.pretty_print(debug.getinfo(1).source:sub(2):gsub("init.lua", ""))
snippet_path = debug.getinfo(1).source:sub(2):gsub("init.lua", "luasnippets")
require("luasnip.loaders.from_lua").load({paths = snippet_path })

-- info = debug.getinfo(1)
-- print(info.source:sub(2):gsub("init.lua", ""))
