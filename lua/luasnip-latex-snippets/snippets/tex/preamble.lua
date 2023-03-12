-- snippets for preamble environments
local ls = require("luasnip")
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local tex = require("snippets.tex.utils").conditions

return {
    -- user stuff like usepackage

    -- package writer stuff like NewDocumentCommand 
}
