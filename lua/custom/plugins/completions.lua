return { -- Completion framework
{
    'hrsh7th/nvim-cmp',
    dependencies = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lua',
                    'hrsh7th/cmp-nvim-lsp-signature-help', 'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip'},
    config = function()
        local cmp = require 'cmp'
        cmp.setup {
            snippet = {
                expand = function(args)
                    vim.fn['vsnip#anonymous'](args.body)
                end
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm {
                    select = true
                },
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item()
            },
            sources = cmp.config.sources {{
                name = 'nvim_lsp'
            }, {
                name = 'nvim_lsp_signature_help'
            }, {
                name = 'vsnip'
            }, {
                name = 'path'
            }, {
                name = 'buffer'
            }, {
                name = 'nvim_lua'
            }},
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered()
            }
        }
    end
}}
