local opt = vim.opt

opt.relativenumber = true
opt.number = true


-- tab & indentation
opt.tabstop = 2       -- 2 spaces for tabs
opt.shiftwidth = 2    -- 2 spaces for indent width
opt.expandtab = true  --expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = true

-- search settings
opt.ignorecase = true -- ignore case when searhing
opt.smartcase = true  -- if you include mixed case in your search, assume you want case-sensitive


opt.cursorline = true

-- turn on terguicolors
opt.termguicolors = true
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position


-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register


-- split windows
opt.splitright = true -- split vertival window to the right
opt.splitbelow = true -- split horizental window to the bottom
