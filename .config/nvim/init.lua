require("config.options")
require("config.keymaps")
require("config.lazy")

vim.lsp.enable 'lua_ls'
vim.lsp.enable 'pyright_ls'
vim.lsp.enable 'ruff_ls'

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
