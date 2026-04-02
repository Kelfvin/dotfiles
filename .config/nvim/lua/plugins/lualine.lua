vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons", name = "nvim-web-devicons" },
  { src = "https://github.com/nvim-lualine/lualine.nvim", name = "lualine.nvim" },
})

require("lualine").setup({
  sections = {
    lualine_x = {
      { "encoding" },
      { "fileformat" },
      { "filetype" },
    },
  },
})
