local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tab & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assume you want case-sensitive
opt.hlsearch = true -- highlight search results

opt.cursorline = true

-- turn on true colors
opt.termguicolors = true
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard = "unnamedplus" -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- performance & behavior
opt.updatetime = 250 -- faster completion and diagnostics
opt.timeoutlen = 300 -- faster which-key popup

-- undo & backup
opt.undofile = true -- persistent undo history
opt.undodir = vim.fn.stdpath("data") .. "/undo" -- undo directory
opt.swapfile = false -- disable swapfile

-- scroll padding
opt.scrolloff = 8 -- keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- keep 8 columns left/right of cursor

-- completion
opt.completeopt = { "menu", "menuone", "noselect" } -- completion behavior
opt.pumheight = 10 -- max items in completion popup

-- command line
opt.wildmenu = true -- enhanced command completion
opt.wildoptions = "pum" -- popup menu for wildmenu

-- UI improvements
opt.confirm = true -- confirm before exiting with unsaved changes
opt.fillchars = {
	eob = " ", -- hide ~ at end of buffer
	vert = "│", -- vertical split separator
}

-- disable netrw (use oil.nvim instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
