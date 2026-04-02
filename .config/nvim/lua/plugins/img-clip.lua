vim.pack.add({
	{ src = "https://github.com/HakonHarnes/img-clip.nvim" },
})

vim.keymap.set(
   "n" ,"<leader>p", "<cmd>PasteImage<cr>", {desc = "Paste image from system clipboard"}
)
