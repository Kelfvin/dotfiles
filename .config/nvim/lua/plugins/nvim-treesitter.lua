vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "lua",
    "python",
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
