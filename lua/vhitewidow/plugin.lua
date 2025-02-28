local lazypath = vim.fn.stdpath 'data' .. 'lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'echasnovski/mini.clue', --mini clue
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                transparent = true,
                italic_comments = true,
                hide_fillchars = true,
                borderless_telescope = true,
                terminal_colors = true,
            })
            vim.cmd('colorscheme cyberdream') -- set the colorscheme
        end,
    },
    {
        -- Telescope
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = 'nvim-lua/plenary.nvim'
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
            -- Prefer git instead of curl in order to improve connectivity in some environments
            require('nvim-treesitter.install').prefer_git = true
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
          signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          },
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            { 'folke/neodev.nvim', opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
              local map = function(keys, func, desc)
                vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
              end

              -- Jump to the definition of the word under your cursor.
              --  This is where a variable was first declared, or where a function is defined, etc.
              --  To jump back, press <C-t>.
              --map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

              -- Find references for the word under your cursor.
              map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

              -- Jump to the implementation of the word under your cursor.
              --  Useful when your language has ways of declaring types without an actual implementation.
              map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

              -- Jump to the type of the word under your cursor.
              --  Useful when you're not sure what type a variable is and you want to see
              --  the definition of its *type*, not where it was *defined*.
              map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

              -- Fuzzy find all the symbols in your current document.
              --  Symbols are things like variables, functions, types, etc.
              map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

              -- Fuzzy find all the symbols in your current workspace.
              --  Similar to document symbols, except searches over your entire project.
              map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

              -- Rename the variable under your cursor.
              --  Most Language Servers support renaming across files, etc.
              map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

              -- Execute a code action, usually your cursor needs to be on top of an error
              -- or a suggestion from your LSP for this to activate.
              map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

              -- Opens a popup that displays documentation about the word under your cursor
              --  See `:help K` for why this keymap.
              map('K', vim.lsp.buf.hover, 'Hover Documentation')

              -- WARN: This is not Goto Definition, this is Goto Declaration.
              --  For example, in C this would take you to the header.
              map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

              -- The following two autocommands are used to highlight references of the
              -- word under your cursor when your cursor rests there for a little while.
              --    See `:help CursorHold` for information about when this is executed
              --
              -- When you move your cursor, the highlights will be cleared (the second autocommand).
              local client = vim.lsp.get_client_by_id(event.data.client_id)
              if client and client.server_capabilities.documentHighlightProvider then
                local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                  buffer = event.buf,
                  group = highlight_augroup,
                  callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                  buffer = event.buf,
                  group = highlight_augroup,
                  callback = vim.lsp.buf.clear_references,
                })

                vim.api.nvim_create_autocmd('LspDetach', {
                  group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                  callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                  end,
                })
              end

              -- The following autocommand is used to enable inlay hints in your
              -- code, if the language server you are using supports them
              --
              -- This may be unwanted, since they displace some of your code
              if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                map('<leader>th', function()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end, '[T]oggle Inlay [H]ints')
              end
            end,
          })
          --local capabilities = vim.lsp.protocol.make_client_capabilities()
          --capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
          
          local servers = {
              csharp_ls = {},
              lua_ls = {
                  settings = {
                      Lua = {
                          completion = {
                              callSnippet = 'Replace',
                          },
                      },
                  },
              },
              angularls = {}
          }
          -- Ensure the servers and tools above are installed
          --  To check the current status of installed tools and/or manually install
          --  other tools, you can run
          --    :Mason
          --  You can press `g?` for help in this menu.
          require('mason').setup()
          require('mason-lspconfig').setup {
              handlers = {
                  function(server_name)
                      local server = servers[server_name] or {}
                      require('lspconfig')[server_name].setup(server)
                  end,
              },
          }
        end,
    },
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {
                -- Snippet engine & its associated nvim-cmp source
                'L3MON4D3/LuaSnip',
                build = (function()
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependecies = {
                },
            },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            luasnip.config.setup {}

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                mapping = cmp.mapping.preset.insert {
                  -- Select the [n]ext item
                  ['<C-n>'] = cmp.mapping.select_next_item(),
                  -- Select the [p]revious item
                  ['<C-p>'] = cmp.mapping.select_prev_item(),

                  -- Scroll the documentation window [b]ack / [f]orward
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),

                  -- Accept ([y]es) the completion.
                  --  This will auto-import if your LSP supports it.
                  --  This will expand snippets if the LSP sent a snippet.
                  ['<C-y>'] = cmp.mapping.confirm { select = true },

                  -- If you prefer more traditional completion keymaps,
                  -- you can uncomment the following lines
                  --['<CR>'] = cmp.mapping.confirm { select = true },
                  --['<Tab>'] = cmp.mapping.select_next_item(),
                  --['<S-Tab>'] = cmp.mapping.select_prev_item(),

                  -- Manually trigger a completion from nvim-cmp.
                  --  Generally you don't need this, because nvim-cmp will display
                  --  completions whenever it has completion options available.
                  ['<C-Space>'] = cmp.mapping.complete {},

                  -- Think of <c-l> as moving to the right of your snippet expansion.
                  --  So if you have a snippet that's like:
                  --  function $name($args)
                  --    $body
                  --  end
                  --
                  -- <c-l> will move you to the right of each of the expansion locations.
                  -- <c-h> is similar, except moving you backwards.
                  ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                      luasnip.expand_or_jump()
                    end
                  end, { 'i', 's' }),
                  ['<C-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                      luasnip.jump(-1)
                    end
                  end, { 'i', 's' }),

                  -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                  --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                },
                sources = {
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
                  { name = 'path' },
                },
            }
        end,
    },
})
