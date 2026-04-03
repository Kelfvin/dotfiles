--          ╭─────────────────────────────────────────────────────────╮
--          │                     basic settings                      │
--          ╰─────────────────────────────────────────────────────────╯
require("config.options")
require("config.keymaps")

--          ╭─────────────────────────────────────────────────────────╮
--          │                      lsp settings                       │
--          ╰─────────────────────────────────────────────────────────╯
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright_ls")
vim.lsp.enable("ruff_ls")

--          ╭─────────────────────────────────────────────────────────╮
--          │                         plugins                         │
--          ╰─────────────────────────────────────────────────────────╯
require("plugins.catppuccin")
require("plugins.snacks")
require("plugins.which_key")
require("plugins.vim-tmux-navigator")
require("plugins.oil")
require("plugins.bullets")
require("plugins.nvim-treesitter")
require("plugins.render-markdown")
require("plugins.box_comment")
require("plugins.vim-maximizer")
require("plugins.img-clip")
require("plugins.conform")
require("plugins.mason")
require("plugins.completion")
require("plugins.bufferline")
require("plugins.lualine")
require("plugins.toggleterm")
require("plugins.auto_session")
