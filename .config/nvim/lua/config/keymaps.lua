vim.g.mapleader = " "

local keymap = vim.keymap

-- save file
keymap.set("n","<C-s>",":w<CR>",{ desc = "Save file"})

-- format: keymap.set("mode","from_keys","to_keys", {desc=""})
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jk"})


keymap.set("n", "Q", ":qa<CR>", { desc = "Exit neovim"})

-- h: no hilight
keymap.set("n", "<leader>nh", ":nohl<CR>", {desc = "Clear search hilights"})

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", {desc = "Increment number"})
keymap.set("n", "<leader>-", "<C-x>", {desc = "Decrement number"})

-- reload config
keymap.set("n", "<leader>r", ":source %<CR>", {desc = "reload config"})

-- window management
keymap.set("n","<leader>sv","<C-w>v", {desc = "Split window vertically"})
keymap.set("n","<leader>sh","<C-w>s", {desc = "Split window horizentally"})
keymap.set("n","<leader>se","<C-w>=", {desc = "Make window equal zise"})
keymap.set("n","<leader>sx","<cmd>close<CR>", {desc = "Close curren split"})

-- tab management
keymap.set("n", "<leader>to","<cmd>tabnew<CR>", {desc="Open new tab"})
keymap.set("n", "<leader>tx","<cmd>tabclose<CR>", {desc="Close current tab"})
keymap.set("n", "<leader>tn","<cmd>tabn<CR>", {desc="Go to next tab"})
keymap.set("n", "<leader>tp","<cmd>tabp<CR>", {desc="Go to previous tab"})
keymap.set("n", "<leader>tf","<cmd>tabnew %<CR>", {desc="Open current buffer in new tab"})


-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "保存文件" })
keymap.set("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "保存文件" })
