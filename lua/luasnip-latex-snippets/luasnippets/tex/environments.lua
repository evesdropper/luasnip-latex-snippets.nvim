-- [
-- snip_env + autosnippets
-- ]
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

--[
-- personal imports
--]
local tex = require("luasnip-latex-snippets.luasnippets.tex.utils.conditions")
local make_condition = require("luasnip.extras.conditions").make_condition
local in_bullets_cond = make_condition(tex.in_bullets)
local line_begin = require("luasnip.extras.conditions.expand").line_begin

M = {
    s({ trig='beg', name='begin/end', dscr='begin/end environment (generic)'},
    fmta([[
    \begin{<>}
    <>
    \end{<>}
    ]],
    { i(1), i(0), rep(1) }
    ), { condition = tex.in_text, show_condition = tex.in_text }),

    s({ trig = "-i", name = "itemize", dscr = "bullet points (itemize)" },
	fmta([[ 
    \begin{itemize}
    \item <>
    \end{itemize}
    ]],
	{ c(1, { i(0), sn(nil, fmta(
		[[
        [<>] <>
        ]],
		{ i(1), i(0) })) })
    }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }),

    -- requires enumitem
	s({ trig = "-e", name = "enumerate", dscr = "numbered list (enumerate)" },
    fmta([[ 
    \begin{enumerate}<>
    \item <>
    \end{enumerate}
    ]],
	{c(1, { t(""), sn(nil, fmta(
		[[
        [label=<>]
        ]],
        { c(1, { t("(\\alph*)"), t("(\\roman*)"), i(1) }) })) }),
	c(2, { i(0), sn(nil, fmta(
        [[
        [<>] <>
        ]],
        { i(1), i(0) })) })
    }
    ),
	{ condition = tex.in_text, show_condition = tex.in_text }),

    -- generate new bullet points
	autosnippet({ trig = "--", hidden = true }, { t("\\item") },
	{ condition = in_bullets_cond * line_begin, show_condition = in_bullets_cond * line_begin }
	),
	autosnippet({ trig = "!-", name = "bullet point", dscr = "bullet point with custom text" },
	fmta([[ 
    \item [<>]<>
    ]],
	{ i(1), i(0) }), 	
	{ condition = in_bullets_cond * line_begin, show_condition = in_bullets_cond * line_begin }
	),
}

return M
