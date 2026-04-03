vim.pack.add({
	{ src = "https://github.com/szw/vim-maximizer", name = "vim-maximizer" },
})

vim.keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" })
