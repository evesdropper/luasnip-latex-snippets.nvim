--[
-- LuaSnip Conditions
--]
local has_treesitter, ts = pcall(require, 'vim.treesitter')
local _, treesitter = pcall(require, 'vim.treesitter')

local M = {}

-- treesitter, using fn from https://github.com/kunzaatko/nvim-dots/blob/trunk/lua/snippets/tex/utils/conditions.lua to grab environments as well
local get_node_at_cursor = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] }
    local lang = vim.bo.filetype
    if lang == 'tex' then
        lang = 'latex'
    end
    local ok, parser = pcall(ts.get_parser, 0, lang)
    if not ok or not parser then
        return
    end
    local root_tree = parser:parse()[1]
    local root = root_tree and root_tree:root()

    if not root then
        return
    end

    return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

local function in_region(zone_environments, zone_nodes, opts)
    opts = opts or {}
    vim.tbl_extend('keep', opts, { no_environment = false, no_treesitter = true, default = false })
    --luacheck: max line length 120
    if not has_treesitter then
        return opts.no_treesitter
    end
    local no_env = true
    local buf = vim.api.nvim_get_current_buf()
    local node = get_node_at_cursor()
    while node do
        if zone_nodes[node:type()] ~= nil then
            return zone_nodes[node:type()]
        end

        if node:type() == 'generic_environment' then
            local begin = node:child(0)
            local names = begin and begin:field 'name'

            if names and names[1] then
                local env_name = treesitter.get_node_text(names[1], buf):match '{([a-zA-Z%d%*]*)}'
                if zone_environments[env_name] ~= nil then
                    return zone_environments[env_name]
                end
            end
            no_env = false
        end
        node = node:parent()
    end
    if no_env then
        return opts.no_environment
    else
        return opts.default
    end
end

local TEX_MATH_ENVIRONMENTS = {
    math = true,
    displaymath = true,
    equation = true,
    multline = true,
    eqnarray = true,
    align = true,
    [ [[align*]] ] = true,
    array = true,
    split = true,
    alignat = true,
    gather = true,
    flalign = true,
    [ [[flalign*]] ] = true,
    aligned = true,
}

local TEX_MD_MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
    math_environment = true,
    text_mode = false,
    latex_block = true,
    latex_span_delimiter = true,
}

local TEX_ALIGN_ENVIRONMENTS = {
    align = true,
    [ [[align*]] ] = true,
    flalign = true,
    [ [[flalign*]] ] = true,
    aligned = true,
    split = true,
}

local TEX_LIST_ENVIRONMENTS = {
    itemize = true,
    enumerate = true,
    description = true,
}

-- math / not math zones
function M.in_math()
    return in_region(TEX_MATH_ENVIRONMENTS, TEX_MD_MATH_NODES) or vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

-- comment detection
function M.in_comment()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
end

-- document class
function M.in_beamer()
    return vim.b.vimtex["documentclass"] == "beamer"
end

-- general env function - needed for VimTeX; otherwise find the relevant treesitter nodes
local function env(name)
    local is_inside = vim.fn["vimtex#env#is_inside"](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

function M.in_text()
    return (in_region({ document = true }, {}) or env("document")) and not M.in_math()
end

function M.in_preamble()
    return not in_region({ document = true }, {}) or not env("document")
end

function M.in_tikz()
    return in_region({ tikzpicture = true }, {}) or  env("tikzpicture")
end

function M.in_bullets()
    return in_region(TEX_LIST_ENVIRONMENTS, {}) or env("itemize") or env("enumerate") or env("description")
end

function M.in_align()
    return in_region(TEX_ALIGN_ENVIRONMENTS, {}) or env("align") or env("align*") or env("aligned")
end

return M
