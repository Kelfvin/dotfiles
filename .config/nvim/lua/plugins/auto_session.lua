vim.pack.add({
  { src = "https://github.com/rmagatti/auto-session", name = "auto-session" },
})

require("auto-session").setup({
  auto_restore = true,
  session_lens = {
    load_on_setup = true,
    previewer = false,
    mappings = {
      delete_session = { "i", "<C-D>" },
      alternate_session = { "i", "<C-S>" },
      copy_session = { "i", "<C-Y>" },
    },
    theme_conf = {
      border = true,
    },
  },
})

vim.keymap.set("n", "<leader>wr", "<cmd>SessionSearch<CR>", { desc = "Session search" })
vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session" })
vim.keymap.set("n", "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", { desc = "Toggle autosave" })
