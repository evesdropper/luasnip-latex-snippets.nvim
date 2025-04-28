local M = {}

local ts = vim.treesitter

local MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
    math_environment = true,
}

local CODE_BLOCK_NODES = { -- Add this to define code block node types
    fenced_code_block = true,
    indented_code_block = true, -- Optional: include indented code blocks as well if needed
}

local COMMENT = {
    ['comment'] = true,
    ['line_comment'] = true,
    ['block_comment'] = true,
    ['comment_environment'] = true,
}


-- taken from https://github.com/nvim-treesitter/nvim-treesitter/issues/1184#issuecomment-1079844699
local function get_node_at_cursor()
    local buf = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    col = col - 1

    local ok, parser = pcall(ts.get_parser, buf, "latex")
    if not ok or not parser then return end

    local root_tree = parser:parse()[1]
    local root = root_tree and root_tree:root()

    if not root then return end

    return root:named_descendant_for_range(row, col, row, col)
end

function M.in_text(check_parent)
    local node = vim.treesitter.get_node({ ignore_injections = false })

    -- Check for code blocks in any filetype
    local block_node = node
    while block_node do
        if CODE_BLOCK_NODES[block_node:type()] then
            return true -- If in a code block, always consider it text
        end
        block_node = block_node:parent()
    end

    while node do
        if node:type() == "text_mode" then
            if check_parent then
                -- For \text{}
                local parent = node:parent()
                if parent and MATH_NODES[parent:type()] then return false end
            end
            return true
        elseif MATH_NODES[node:type()] then
            return false
        end
        node = node:parent()
    end
    return true
end

function M.in_mathzone()
    local node = get_node_at_cursor()
    while node do
        if node:type() == "text_mode" then
            return false
        elseif MATH_NODES[node:type()] then
            return true
        end
        node = node:parent()
    end
    return false
end

function M.in_comment()
    local node = get_node_at_cursor()
    while node do
        if COMMENT[node:type()] then
            return true
        end
        node = node:parent()
    end
    return false
end

return M
