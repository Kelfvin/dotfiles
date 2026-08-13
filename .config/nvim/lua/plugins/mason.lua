vim.pack.add({
	{ src = "https://github.com/williamboman/mason.nvim" },
})

local mason = require("mason")
local registry = require("mason-registry")

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Keep the editor usable on first launch while installing the tools required by
-- the LSP and formatter configuration.  Mason's registry is asynchronous, so
-- installations are started only after the registry is ready.
local ensure_installed = {
	"lua-language-server",
	"pyright",
	"ruff",
	"clangd",
	"stylua",
}

local function ensure_tools()
	for _, name in ipairs(ensure_installed) do
		local ok, package = pcall(registry.get_package, name)
		if ok and not package:is_installed() and not package:is_installing() then
			package:install()
		end
	end
end

if registry.sources:is_all_installed() then
	ensure_tools()
else
	registry.refresh(function(success)
		if success then
			ensure_tools()
		else
			vim.notify("Mason registry refresh failed; install LSP tools manually.", vim.log.levels.WARN)
		end
	end)
end
