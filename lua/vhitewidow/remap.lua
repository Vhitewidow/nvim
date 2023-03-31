vim.g.mapleader = " "

-- cancel when in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Press Enter to create a new line and staying on the current line
vim.keymap.set("n", "<CR>", "o<Esc>k")
