vim.pack.add({
	{ src = "https://github.com/christoomey/vim-tmux-navigator", name = "vim-tmux-navigator" },
})

vim.keymap.set("n", "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>")
vim.keymap.set("n", "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>")
