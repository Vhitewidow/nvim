local tsconfigs = require('nvim-treesitter.configs')
tsconfigs.setup({
    highlight = {
        setup = true,
        additional_vim_regex_highlighting = false,
    },
})
