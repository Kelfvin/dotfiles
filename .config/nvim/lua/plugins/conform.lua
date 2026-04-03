vim.pack.add({
  { src = "https://github.com/stevearc/conform.nvim" },
})

conform = require("conform")
conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})
