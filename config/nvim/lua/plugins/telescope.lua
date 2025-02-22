return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = { 
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      config = function()
        -- You dont need to set any of these options. These are the default ones. Only
        -- the loading is important
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup({
          defaults = {
            -- mappings = {
            --   i = {
            --     ["<C-j>"] = actions.move_selection_next,
            --     ["<C-k>"] = actions.move_selection_previous,
            --     ["<C-q>"] = actions.send_selection_to_qflist + actions.open_qflist,
            --   },
            -- },
          },
          extensions = {
            fzf = {
              fuzzy = true,                    -- false will only do exact matching
              override_generic_sorter = true,  -- override the generic sorter
              override_file_sorter = true,     -- override the file sorter
              case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                               -- the default case_mode is "smart_case"
            },
          }
        })
        -- To get fzf loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        telescope.load_extension('fzf')

        -- add keymaps
        keymap = vim.keymap
        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

      end,
}
