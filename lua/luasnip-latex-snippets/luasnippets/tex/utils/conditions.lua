--[
-- LuaSnip Conditions
--]

local M = {}

local ts = require("luasnip-latex-snippets.luasnippets.tex.utils.ts_utils")

-- math / not math zones

function M.in_math()
    return ts.in_mathzone()
end

-- comment detection
function M.in_comment()
    return ts.in_comment()
end

-- document class
function M.in_beamer()
	return vim.b.vimtex["documentclass"] == "beamer"
end

-- general env function
local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

function M.in_preamble()
	return not env("document")
end

function M.in_text()
	return env("document") and not M.in_math()
end

function M.in_tikz()
	return env("tikzpicture")
end

function M.in_bullets()
	return env("itemize") or env("enumerate")
end

function M.in_align()
	return env("align") or env("align*") or env("aligned")
end

function M.show_line_begin(line_to_cursor)
    return #line_to_cursor <= 3
end

return M
