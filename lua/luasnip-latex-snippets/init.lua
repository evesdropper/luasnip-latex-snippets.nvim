#!/bin/lua
require("luasnip.loaders.from_lua").load(vim.api.nvim_get_runtime_file("luasnippets")) 

-- info = debug.getinfo(1, "Sl")
-- print(info.source:sub(2))
