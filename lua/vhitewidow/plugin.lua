-- You are using packer.nvim as a plugin manager
-- After modifiying the needed packages run :PackerSync in nvim to update

return require('packer').startup(function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    -- color scheme
    -- use 'Mofiqul/vscode.nvim'
    use {
        'scottmckendry/cyberdream.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                transparent = true,
                italic_comments = true,
                hide_fillchars = true,
                borderless_telescope = true,
                terminal_colors = true
            })
        end,
    }

    -- Telescope
    use {
	    'nvim-telescope/telescope.nvim', branch = '0.1.x',
	    requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- mini.clue
    use 'echasnovski/mini.clue'

    --nvim-treesitter
    use {
        'nvim-treesitter/nvim-treesitter', 
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

end)
