-- snippets for LaTeX environments
local ls = require("luasnip")
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local tex = require("luasnip-latex-snippets.luasnippets.tex.utils").conditions

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

}

return M
