
return {
    "williamboman/mason.nvim",
    dependencies = {"williamboman/mason-lspconfig.nvim",},
    config = function()
      require("mason").setup({
          ui = {
              icons = {
                  package_installed = "✓",
                  package_pending = "➜",
                  package_uninstalled = "✗"
              }
          }
      })

      mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = { 
          "lua_ls", 
          "rust_analyzer",        -- rust
          "ruff",                 -- python
          "pyright",
        },
      })
    end,
}
