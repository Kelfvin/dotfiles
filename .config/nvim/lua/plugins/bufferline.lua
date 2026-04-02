vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons", name = "nvim-web-devicons" },
  { src = "https://github.com/akinsho/bufferline.nvim", name = "bufferline.nvim" },
})

require("bufferline").setup({
  options = {
    mode = "tabs",
    separator_style = "slant",
  },
})
