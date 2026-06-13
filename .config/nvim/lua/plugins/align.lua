vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.align", name = "mini.align" },
})

local align = require("mini.align")
align.setup()

-- Use <leader>a as an alias for the default align mapping (ga)
vim.keymap.set({ "n", "v" }, "<leader>a", "ga", { remap = true, desc = "Align" })
