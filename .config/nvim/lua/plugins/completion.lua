return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  event = {"BufReadPost","BufNewFile"}, -- 只有在打开文件和创建新文件的时候
  version = '*',
  opts = {
    completion = {
      documentation = {
        auto_show = true,
      }
    },
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = { 
      preset = 'super-tab',      
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },

    signature = {
      enabled = true,
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer','markdown' },
      providers = {
          markdown = {
              name = 'RenderMarkdown',
              module = 'render-markdown.integ.blink',
              fallbacks = { 'lsp' },
          },
      },

    },
  },
  opts_extend = { "sources.default" }
}
