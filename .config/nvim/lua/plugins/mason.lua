vim.pack.add({
	{ src = "https://github.com/williamboman/mason.nvim" },
})

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

