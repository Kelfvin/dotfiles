return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { 
            "c", 
            "lua", 
            "vim", 
            "vimdoc", 
            "query", 
            "elixir", 
            "heex", 
            "javascript",
            "html", 
            "css",
            "latex", 
            "norg", 
            "scss", 
            "svelte", 
            "typst", 
            "vue",
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
 }
