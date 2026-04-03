vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
})

local sitter = require("nvim-treesitter")

sitter.setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})

sitter.install({ "rust", "javascript", "zig" })
