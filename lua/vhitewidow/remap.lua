vim.g.mapleader = " "

-- cancel when in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Press Enter to create a new line and staying on the current line
vim.keymap.set("n", "<CR>", "o<Esc>k")

-- Telescope
local builting = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builting.find_files, {})
vim.keymap.set('n', '<leader>fg', builting.live_grep, {})
vim.keymap.set('n', '<leader>fb', builting.buffers, {})
vim.keymap.set('n', '<leader>fh', builting.help_tags, {})
