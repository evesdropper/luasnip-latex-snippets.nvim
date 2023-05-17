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

M = {
	autosnippet({ trig = "lim", name = "lim(sup|inf)", dscr = "lim(sup|inf)" },
    fmta([[ 
    \lim<><><>
    ]],
	{c(1, { t(""), t("sup"), t("inf") }),
	c(2, { t(""), fmta([[_{<> \to <>}]], { i(1, "n"), i(2, "\\infty") }) }),
	i(0)}
    ),
	{ condition = tex.in_math, show_condition = tex.in_math }),
	autosnippet({ trig = "sum", name = "summation", dscr = "summation" },
	fmta([[
    \sum<> <>
    ]],
    { c(1, {fmta([[_{<>}^{<>}]], {i(1, "i = 0"), i(2, "\\infty")}), t("")}), i(0) }),
    { condition = tex.in_math, show_condition = tex.in_math }
    ),
	autosnippet({ trig = "prod", name = "product", dscr = "product" },
    fmta([[
    \prod<> <>
    ]],
	{ c(1, {fmta([[_{<>}^{<>}]], {i(1, "i = 0"), i(2, "\\infty")}), t("")}), i(0) }),
	{ condition = tex.in_math, show_condition = tex.in_math }
    ),
	autosnippet({ trig = "cprod", name = "coproduct", dscr = "coproduct" },
    fmta([[
    \coprod<> <>
    ]],
	{ c(1, {fmta([[_{<>}^{<>}]], {i(1, "i = 0"), i(2, "\\infty")}), t("")}), i(0) }),
	{ condition = tex.in_math, show_condition = tex.in_math }
    ),
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
}

local auto_backslash_snippets = {}
for _, v in ipairs(auto_backslash_specs) do
    table.insert(auto_backslash_snippets, auto_backslash_snippet({ trig = v }, { condition = tex.in_math }))
end
vim.list_extend(M, auto_backslash_snippets)

-- Symbols/Commands
-- TODO: fix symbols once font works
local greek_specs = {
	alpha = { context = { name = "α" }, command = [[\alpha]] },
	beta = { context = { name = "β" }, command = [[\beta]] },
	gam = { context = { name = "β" }, command = [[\gamma]] },
	omega = { context = { name = "ω" }, command = [[\omega]] },
	Omega = { context = { name = "Ω" }, command = [[\Omega]] },
	delta = { context = { name = "δ" }, command = [[\delta]] },
	DD = { context = { name = "Δ" }, command = [[\Delta]] },
	eps = { context = { name = "ε" , priority = 500 }, command = [[\epsilon]] },
	eta = { context = { name = "θ" , priority = 500}, command = [[\eta]] },
	zeta = { context = { name = "θ" }, command = [[\zeta]] },
	theta = { context = { name = "θ" }, command = [[\theta]] },
	lmbd = { context = { name = "λ" }, command = [[\lambda]] },
	Lmbd = { context = { name = "Λ" }, command = [[\Lambda]] },
	mu = { context = { name = "μ" }, command = [[\mu]] },
	nu = { context = { name = "μ" }, command = [[\nu]] },
	pi = { context = { name = "π" }, command = [[\pi]] },
	rho = { context = { name = "π" }, command = [[\rho]] },
	sig = { context = { name = "σ" }, command = [[\sigma]] },
	Sig = { context = { name = "Σ" }, command = [[\Sigma]] },
	xi = { context = { name = "Σ" }, command = [[\xi]] },
	vphi = { context = { name = "φ" }, command = [[\varphi]] },
	veps = { context = { name = "ε" }, command = [[\varepsilon]] },
}

local greek_snippets = {}
for k, v in pairs(greek_specs) do
	table.insert(
		greek_snippets,
		symbol_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.command, { condition = tex.in_math })
	)
end
vim.list_extend(M, greek_snippets)


return M
