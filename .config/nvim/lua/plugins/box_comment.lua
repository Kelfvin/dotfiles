local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Simple top/bottom line comment box, left aligned, no side borders
local function simple_comment_box(cmd_opts)
	local lstart = cmd_opts.line1
	local lend = cmd_opts.line2

	local lines = vim.api.nvim_buf_get_lines(0, lstart - 1, lend, false)
	local indent = vim.fn.indent(lstart)
	local indent_str = string.rep(" ", indent)

	local comment_prefix = vim.bo.commentstring
	if comment_prefix:find("%%s") then
		comment_prefix = comment_prefix:gsub("%%s", "")
	end
	comment_prefix = comment_prefix:gsub("%s+$", "")

	local prefix = indent_str .. comment_prefix

	local width = 60
	local sep = prefix .. string.rep("-", width)

	local new_lines = { sep }
	for _, line in ipairs(lines) do
		local text = line:gsub("^%s+", "")
		table.insert(new_lines, prefix .. " " .. text)
	end
	table.insert(new_lines, sep)

	vim.api.nvim_buf_set_lines(0, lstart - 1, lend, false, new_lines)
end

vim.api.nvim_create_user_command("CBSimpleBox", simple_comment_box, { range = true })

keymap({ "n", "v" }, "<Leader>cb", ":CBSimpleBox<CR>", opts)
