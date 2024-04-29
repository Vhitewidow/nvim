-- line numbers
vim.o.number = true
vim.o.relativenumber = true

-- tab settings
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- highlight search results (after pressing Enter)
vim.o.hlsearch = true

-- highlight all patterns WHILE typing the search pattern
vim.o.incsearch = true

-- show matching brackets
vim.o.showmatch = true

-- show cursorline
vim.o.cursorline = true

-- enable true color (supported by Windows Terminal)
vim.o.termguicolors = true

-- copy to system clipboard
vim.o.clipboard = 'unnamed'

-- color scheme
require('cyberdream').load()
