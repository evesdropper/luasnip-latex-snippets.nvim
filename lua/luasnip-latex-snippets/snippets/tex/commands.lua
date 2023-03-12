-- Snippets for LaTeX Commands
local ls = require("luasnip")
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local tex = require("luasnip-latex-snippets.snippets.tex.utils").conditions

local reference_snippet_table = {
    a = "auto",
    c = "c",
    C = "C",
    e = "eq",
    r = ""
}

return {

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
