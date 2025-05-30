return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- optionally enable 24-bit colour
    vim.opt.termguicolors = true

    -- empty setup using defaults
    require("nvim-tree").setup()

    -- OR setup with some options
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 35,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true;
        },
        group_empty = true,
      },
      -- disable window_picker for explorer work well with
      -- window splits
      actions = {
        open_file = {
         window_picker = {
          enable = false,
         },
        },
      },
      filters = {
        custom = {".DS_Store"}
      },
      git = {
        ignore = false,
      }
    })

    -- set keymaps
    local keymap = vim.keymap

    keymap.set("n", "<leader>ee","<cmd>NvimTreeToggle<CR>", {desc="Toggle file explorer"})
    keymap.set("n", "<leader>ef","<cmd>NvimTreeFindFileToggle<CR>", {desc="Toggle file explorer on current"}) 
    keymap.set("n", "<leader>ec","<cmd>NvimTreeCollapse<CR>", {desc="Collapse file explorer"})
    keymap.set("n", "<leader>er","<cmd>NvimTreeRefresh<CR>", {desc="Refresh file explorer"})
  end,
}
