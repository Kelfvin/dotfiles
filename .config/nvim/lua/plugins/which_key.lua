vim.pack.add({
  { src = "https://github.com/folke/which-key.nvim", name = "which-key.nvim" },
})

require("which-key").setup({
  preset = "modern",
})

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps" })
