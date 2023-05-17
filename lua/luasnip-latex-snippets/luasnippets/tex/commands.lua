-- Snippets for LaTeX Commands
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local tex = require("luasnip-latex-snippets.luasnippets.tex.utils").conditions

local reference_snippet_table = {
    a = "auto",
    c = "c",
    C = "C",
    e = "eq",
    r = ""
}

M = {

    --[
    -- Labels/References
    --]
    -- personally perfer \label{type:number/value}
    autosnippet({ trig='alab', name='label', dscr='add a label'},
    fmta([[
    \label{<>:<>}
    ]],
    { i(1), i(0) }),
    { condition = tex.in_text, show_condition = tex.in_text }),

    autosnippet({ trig='([acCer])ref', name='(acC|eq)?ref', dscr='add a reference (with autoref, cref, eqref)', regTrig = true, hidden = true},
    fmta([[
    \<>ref{<>:<>}
    ]],
    { f(function (_, snip)
        return reference_snippet_table[snip.captures[1]]
    end),
    i(1), i(0) })
    { condition = tex.in_text, show_condition = tex.in_text }),
}

return M
