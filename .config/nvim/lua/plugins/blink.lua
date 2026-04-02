vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", name = "blink.cmp" },
})

require("blink.cmp").setup({
  completion = {
    documentation = {
      auto_show = true,
    },
  },
  keymap = {
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    preset = "super-tab",
  },
  signature = {
    enabled = true,
  },
  cmdline = {
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
  sources = {
    providers = {
      snippets = { score_offset = 1000 },
    },
  },
})
