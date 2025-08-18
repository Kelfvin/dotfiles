return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = 'master',
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = {
            "c",
            "lua",
            "py",
            "vim",
            "vimdoc",
            "javascript",
            "html",
            "css",
            "latex",
            "typst",
            "vue",
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
 }
