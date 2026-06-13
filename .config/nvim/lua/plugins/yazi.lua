vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary.nvim" },
	{ src = "https://github.com/mikavilpas/yazi.nvim", name = "yazi.nvim" },
})

local Snacks = require("snacks")

require("yazi").setup({
	open_for_directories = false,
	floating_window_scaling_factor = 0.9,
	yazi_floating_window_border = "rounded",
	integrations = {
		grep_in_directory = function(directory)
			Snacks.picker.grep({ cwd = directory, hidden = true })
		end,
		grep_in_selected_files = function(selected_files)
			Snacks.picker.grep({ dirs = selected_files, hidden = true })
		end,
	},
})

local map = function(key, func, desc)
	vim.keymap.set("n", key, func, { desc = desc })
end

map("<leader>y", function()
	require("yazi").yazi()
end, "Open yazi at current file")

map("<leader>Y", function()
	require("yazi").yazi(nil, vim.fn.getcwd())
end, "Open yazi in working directory")

map("<leader>ty", function()
	require("yazi").toggle()
end, "Toggle last yazi session")
