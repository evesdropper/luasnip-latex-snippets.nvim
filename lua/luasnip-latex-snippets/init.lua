snippet_path = debug.getinfo(1).source:sub(2):gsub("init.lua", "luasnippets")
require("luasnip.loaders.from_lua").lazy_load({ paths = snippet_path })
