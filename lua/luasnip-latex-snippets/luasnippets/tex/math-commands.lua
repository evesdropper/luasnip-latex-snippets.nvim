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

-- [
-- personal imports
-- ]
local tex = require("luasnip-latex-snippets.luasnippets.tex.utils.conditions")
local auto_backslash_snippet = require("luasnip-latex-snippets.luasnippets.tex.utils.scaffolding").auto_backslash_snippet
local symbol_snippet = require("luasnip-latex-snippets.luasnippets.tex.utils.scaffolding").symbol_snippet
local single_command_snippet = require("luasnip-latex-snippets.luasnippets.tex.utils.scaffolding").single_command_snippet
local postfix_snippet = require("luasnip-latex-snippets.luasnippets.tex.utils.scaffolding").postfix_snippet

-- fractions (parentheses case)
local generate_fraction = function (_, snip)
    local stripped = snip.captures[1]
    local depth = 0
    local j = #stripped
    while true do
        local c = stripped:sub(j, j)
        if c == "(" then
            depth = depth + 1
        elseif c == ")" then
            depth = depth - 1
        end
        if depth == 0 then
            break
        end
        j = j - 1
    end
    return sn(nil,
        fmta([[
        <>\frac{<>}{<>}
        ]],
        { t(stripped:sub(1, j-1)), t(stripped:sub(j)), i(1)}))
end

M = {
    -- superscripts
    autosnippet({ trig = "sr", wordTrig = false },
    { t("^2") },
    { condition = tex.in_math, show_condition = tex.in_math }),
	autosnippet({ trig = "cb", wordTrig = false },
    { t("^3") },
    { condition = tex.in_math, show_condition = tex.in_math }),
	autosnippet({ trig = "compl", wordTrig = false },
    { t("^{c}") },
    { condition = tex.in_math, show_condition = tex.in_math }),
	autosnippet({ trig = "vtr", wordTrig = false },
    { t("^{T}") },
    { condition = tex.in_math, show_condition = tex.in_math }),
	autosnippet({ trig = "inv", wordTrig = false },
    { t("^{-1}") },
    { condition = tex.in_math, show_condition = tex.in_math }),

    -- fractions
    autosnippet({ trig='//', name='fraction', dscr="fraction (general)"},
    fmta([[
    \frac{<>}{<>}<>
    ]],
    { i(1), i(2), i(0) }),
    { condition = tex.in_math, show_condition = tex.in_math }),
    autosnippet({ trig="((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)\\/", name='fraction', dscr='auto fraction 1', trigEngine="ecma"},
    fmta([[
    \frac{<>}{<>}<>
    ]],
    { f(function (_, snip)
        return snip.captures[1]
    end), i(1), i(0) }),
    { condition = tex.in_math, show_condition = tex.in_math }),
    autosnippet({ trig='(^.*\\))/', name='fraction', dscr='auto fraction 2', trigEngine="ecma" },
    { d(1, generate_fraction) },
    { condition=tex.in_math, show_condition=tex.in_math }),

	autosnippet({ trig = "lim", name = "lim(sup|inf)", dscr = "lim(sup|inf)" },
    fmta([[ 
    \lim<><><>
    ]],
	{c(1, { t(""), t("sup"), t("inf") }),
	c(2, { t(""), fmta([[_{<> \to <>}]], { i(1, "n"), i(2, "\\infty") }) }),
	i(0)}),
	{ condition = tex.in_math, show_condition = tex.in_math }),

	autosnippet({ trig = "sum", name = "summation", dscr = "summation" },
	fmta([[
    \sum<> <>
    ]],
    { c(1, {fmta([[_{<>}^{<>}]], {i(1, "i = 0"), i(2, "\\infty")}), t("")}), i(0) }),
    { condition = tex.in_math, show_condition = tex.in_math }),

	autosnippet({ trig = "prod", name = "product", dscr = "product" },
    fmta([[
    \prod<> <>
    ]],
	{ c(1, {fmta([[_{<>}^{<>}]], {i(1, "i = 0"), i(2, "\\infty")}), t("")}), i(0) }),
	{ condition = tex.in_math, show_condition = tex.in_math }),

	autosnippet({ trig = "cprod", name = "coproduct", dscr = "coproduct" },
    fmta([[
    \coprod<> <>
    ]],
	{ c(1, {fmta([[_{<>}^{<>}]], {i(1, "i = 0"), i(2, "\\infty")}), t("")}), i(0) }),
	{ condition = tex.in_math, show_condition = tex.in_math }),

	autosnippet({ trig = "set", name = "set", dscr = "set" }, -- overload with set builders notation because analysis and algebra cannot agree on a singular notation
	fmta([[
    \{<>\}<>
    ]],
	{ c(1, { r(1, ""), sn(nil, { r(1, ""), t(" \\mid "), i(2) }), sn(nil, { r(1, ""), t(" \\colon "), i(2) })}), i(0) }),
	{ condition = tex.in_math, show_condition = tex.in_math }),

	autosnippet({ trig = "nnn", name = "bigcap", dscr = "bigcap" },
	fmta([[
    \bigcap<> <>
    ]],
	{ c(1, {fmta([[_{<>}^{<>}]], {i(1, "i = 0"), i(2, "\\infty")}), t("")}), i(0) }),
	{ condition = tex.in_math, show_condition = tex.in_math }),

	autosnippet({ trig = "uuu", name = "bigcup", dscr = "bigcup" },
    fmta([[
    \bigcup<> <>
    ]],
	{ c(1, {fmta([[_{<>}^{<>}]], {i(1, "i = 0"), i(2, "\\infty")}), t("")}), i(0) }),
    { condition = tex.in_math, show_condition = tex.in_math }),

	autosnippet({ trig = "bnc", name = "binomial", dscr = "binomial (nCR)" },
	fmta([[
    \binom{<>}{<>}<>
    ]],
    { i(1), i(2), i(0) }),
	{ condition = tex.in_math, show_condition = tex.in_math }),

    autosnippet({ trig='pd', name='partial', dscr='partial derivative'},
    fmta([[
    \frac{\partial <>}{\partial <>}<>
    ]],
    { i(1), i(2), i(0) }),
    { condition = tex.in_math, show_condition = tex.in_math }),
}

-- Auto backslashes
local auto_backslash_specs = {
	"arcsin",
	"sin",
	"arccos",
	"cos",
	"arctan",
	"tan",
	"cot",
	"csc",
	"sec",
	"log",
	"ln",
	"exp",
	"ast",
	"star",
	"perp",
	"sup",
	"inf",
	"det",
	"max",
	"min",
	"argmax",
	"argmin",
    "deg",
    "angle",
}

local auto_backslash_snippets = {}
for _, v in ipairs(auto_backslash_specs) do
    table.insert(auto_backslash_snippets, auto_backslash_snippet({ trig = v }, { condition = tex.in_math }))
end
vim.list_extend(M, auto_backslash_snippets)

-- Symbols/Commands
local greek_specs = {
	alpha = { context = { name = "α" }, command = [[\alpha]] },
	beta = { context = { name = "β" }, command = [[\beta]] },
	gam = { context = { name = "γ" }, command = [[\gamma]] },
	Gam = { context = { name = "Γ" }, command = [[\Gamma]] },
	delta = { context = { name = "δ" }, command = [[\delta]] },
	DD = { context = { name = "Δ" }, command = [[\Delta]] },
	eps = { context = { name = "ε" , priority = 500 }, command = [[\epsilon]] },
    veps = { context = { name = "ε" }, command = [[\varepsilon]] },
    zeta = { context = { name = "ζ" }, command = [[\zeta]] },
	eta = { context = { name = "η" , priority = 500}, command = [[\eta]] },
	theta = { context = { name = "θ" }, command = [[\theta]] },
	Theta = { context = { name = "Θ" }, command = [[\Theta]] },
	iota = { context = { name = "ι" }, command = [[\iota]] },
	kappa = { context = { name = "κ" }, command = [[\kappa]] },
	lmbd = { context = { name = "λ" }, command = [[\lambda]] },
	Lmbd = { context = { name = "Λ" }, command = [[\Lambda]] },
	mu = { context = { name = "μ" }, command = [[\mu]] },
	nu = { context = { name = "ν" }, command = [[\nu]] },
    xi = { context = { name = "ξ" }, command = [[\xi]] },
	pi = { context = { name = "π" }, command = [[\pi]] },
	rho = { context = { name = "ρ" }, command = [[\rho]] },
	sig = { context = { name = "σ" }, command = [[\sigma]] },
	Sig = { context = { name = "Σ" }, command = [[\Sigma]] },
    tau = { context = { name = "τ" }, command = [[\tau]] },
	ups = { context = { name = "υ" }, command = [[\upsilon]] },
    phi = { context = { name = "φ" }, command = [[\phi]] },
    vphi = { context = { name = "φ" }, command = [[\varphi]] },
    chi = { context = { name = "χ" }, command = [[\chi]] },
	psi = { context = { name = "Ψ" }, command = [[\psi]] },
	omega = { context = { name = "ω" }, command = [[\omega]] },
	Omega = { context = { name = "Ω" }, command = [[\Omega]] },
}

local greek_snippets = {}
for k, v in pairs(greek_specs) do
	table.insert(
		greek_snippets,
		symbol_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.command, { condition = tex.in_math, backslash = true })
	)
end
vim.list_extend(M, greek_snippets)

local symbol_specs = {
	-- operators
	["!="] = { context = { name = "!=" }, command = [[\neq]] },
	["<="] = { context = { name = "≤" }, command = [[\leq]] },
	[">="] = { context = { name = "≥" }, command = [[\geq]] },
	["<<"] = { context = { name = "<<" }, command = [[\ll]] },
	[">>"] = { context = { name = ">>" }, command = [[\gg]] },
	["~~"] = { context = { name = "~" }, command = [[\sim]] },
	["~="] = { context = { name = "≈" }, command = [[\approx]] },
	["~-"] = { context = { name = "≃" }, command = [[\simeq]] },
	["-~"] = { context = { name = "⋍" }, command = [[\backsimeq]] },
	["-="] = { context = { name = "≡" }, command = [[\equiv]] },
	["=~"] = { context = { name = "≅" }, command = [[\cong]] },
	[":="] = { context = { name = "≔" }, command = [[\definedas]] },
	["**"] = { context = { name = "·", priority = 100 }, command = [[\cdot]] },
	xx = { context = { name = "×" }, command = [[\times]] },
	["!+"] = { context = { name = "⊕" }, command = [[\oplus]] },
	["!*"] = { context = { name = "⊗" }, command = [[\otimes]] },
	-- sets
	NN = { context = { name = "ℕ" }, command = [[\mathbb{N}]] },
	ZZ = { context = { name = "ℤ" }, command = [[\mathbb{Z}]] },
	QQ = { context = { name = "ℚ" }, command = [[\mathbb{Q}]] },
	RR = { context = { name = "ℝ" }, command = [[\mathbb{R}]] },
	CC = { context = { name = "ℂ" }, command = [[\mathbb{C}]] },
	OO = { context = { name = "∅" }, command = [[\emptyset]] },
	pwr = { context = { name = "P" }, command = [[\powerset]] },
	cc = { context = { name = "⊂" }, command = [[\subset]] },
	cq = { context = { name = "⊆" }, command = [[\subseteq]] },
	qq = { context = { name = "⊃" }, command = [[\supset]] },
	qc = { context = { name = "⊇" }, command = [[\supseteq]] },
	["\\\\\\"] = { context = { name = "⧵" }, command = [[\setminus]] },
	Nn = { context = { name = "∩" }, command = [[\cap]] },
	UU = { context = { name = "∪" }, command = [[\cup]] },
	["::"] = { context = { name = ":" }, command = [[\colon]] },
	-- quantifiers and logic stuffs
	AA = { context = { name = "∀" }, command = [[\forall]] },
	EE = { context = { name = "∃" }, command = [[\exists]] },
	inn = { context = { name = "∈" }, command = [[\in]] },
	notin = { context = { name = "∉" }, command = [[\not\in]] },
	["!-"] = { context = { name = "¬" }, command = [[\lnot]] },
	VV = { context = { name = "∨" }, command = [[\lor]] },
	WW = { context = { name = "∧" }, command = [[\land]] },
    ["!W"] = { context = { name = "∧" }, command = [[\bigwedge]] },
	["=>"] = { context = { name = "⇒" }, command = [[\implies]] },
	["=<"] = { context = { name = "⇐" }, command = [[\impliedby]] },
	iff = { context = { name = "⟺" }, command = [[\iff]] },
	["->"] = { context = { name = "→", priority = 250 }, command = [[\to]] },
	["!>"] = { context = { name = "↦" }, command = [[\mapsto]] },
	["<-"] = { context = { name = "↦", priority = 250}, command = [[\gets]] },
    -- differentials 
	dp = { context = { name = "⇐" }, command = [[\partial]] },
	-- arrows
	["-->"] = { context = { name = "⟶", priority = 500 }, command = [[\longrightarrow]] },
	["<->"] = { context = { name = "↔", priority = 500 }, command = [[\leftrightarrow]] },
	["2>"] = { context = { name = "⇉", priority = 400 }, command = [[\rightrightarrows]] },
	upar = { context = { name = "↑" }, command = [[\uparrow]] },
	dnar = { context = { name = "↓" }, command = [[\downarrow]] },
	-- etc
	ooo = { context = { name = "∞" }, command = [[\infty]] },
	lll = { context = { name = "ℓ" }, command = [[\ell]] },
	dag = { context = { name = "†" }, command = [[\dagger]] },
	["+-"] = { context = { name = "†" }, command = [[\pm]] },
	["-+"] = { context = { name = "†" }, command = [[\mp]] },
}

local symbol_snippets = {}
for k, v in pairs(symbol_specs) do
	table.insert(
		symbol_snippets,
		symbol_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.command, { condition = tex.in_math })
	)
end
vim.list_extend(M, symbol_snippets)

local single_command_math_specs = {
	tt = {
		context = {
			name = "text (math)",
			dscr = "text in math mode",
		},
		command = [[\text]],
	},
	sbf = {
		context = {
			name = "symbf",
			dscr = "bold math text",
		},
		command = [[\symbf]],
	},
	syi = {
		context = {
			name = "symit",
			dscr = "italic math text",
		},
		command = [[\symit]],
	},
	udd = {
		context = {
			name = "underline (math)",
			dscr = "underlined text in math mode",
		},
		command = [[\underline]],
	},
	conj = {
		context = {
			name = "conjugate",
			dscr = "conjugate (overline)",
		},
		command = [[\overline]],
	},
	["__"] = {
		context = {
			name = "subscript",
			dscr = "auto subscript 3",
			wordTrig = false,
		},
		command = [[_]],
	},
	td = {
		context = {
			name = "superscript",
			dscr = "auto superscript alt",
			wordTrig = false,
		},
		command = [[^]],
	},
	sbt = {
		context = {
			name = "substack",
			dscr = "substack for sums/products",
		},
		command = [[\substack]],
	},
	sq = {
		context = {
			name = "sqrt",
			dscr = "sqrt",
		},
		command = [[\sqrt]],
		ext = { choice = true },
	},
    bxd = {
        context = {
            name = "boxed",
            dscr = "boxed answer",
        },
        command = [[\boxed]],
    }
}

local single_command_math_snippets = {}
for k, v in pairs(single_command_math_specs) do
	table.insert(
		single_command_math_snippets,
		single_command_snippet(
			vim.tbl_deep_extend("keep", { trig = k, snippetType = "autosnippet" }, v.context),
			v.command,
			{ condition = tex.in_math },
			v.ext or {}
		)
	)
end
vim.list_extend(M, single_command_math_snippets)

local postfix_math_specs = {
    mbb = {
        context = {
            name = "mathbb",
            dscr =  "math blackboard bold",
        },
        command = {
            pre = [[\mathbb{]],
            post = [[}]],
        }
    },
    mcal = {
        context = {
            name = "mathcal",
            dscr =  "math calligraphic",
        },
        command = {
            pre = [[\mathcal{]],
            post = [[}]],
        }
    },
    mscr = {
        context = {
            name = "mathscr",
            dscr =  "math script",
        },
        command = {
            pre = [[\mathscr{]],
            post = [[}]],
        },
    },
    mfr = {
        context = {
            name = "mathfrak",
            dscr =  "mathfrak",
        },
        command = {
            pre = [[\mathfrak{]],
            post = [[}]],
        },
    },
    hat = {
		context = {
			name = "hat",
			dscr = "hat",
		},
		command = {
            pre = [[\hat{]],
            post = [[}]],
        }
	},
	bar = {
		context = {
			name = "bar",
			dscr = "bar (overline)",
		},
		command = {
            pre = [[\overline{]],
            post = [[}]]
        }
	},
	tld = {
		context = {
			name = "tilde",
            priority = 500,
			dscr = "tilde",
		},
		command = {
            pre = [[\tilde{]],
            post = [[}]]
        }
	}
}

local postfix_math_snippets = {}
for k, v in pairs(postfix_math_specs) do
table.insert(
    postfix_math_snippets,
    postfix_snippet(
        vim.tbl_deep_extend("keep", { trig = k, snippetType = "autosnippet" }, v.context),
        v.command,
        { condition = tex.in_math }
    )
)
end
vim.list_extend(M, postfix_math_snippets)

return M
