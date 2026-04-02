-- basic settings
require("config.options")
require("config.keymaps")

-- lsp settings
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'pyright_ls'
vim.lsp.enable 'ruff_ls'

--plugins
require("plugins.catppuccin")
