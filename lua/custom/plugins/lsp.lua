return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath forN Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE must be loaded before depndants
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'folke/lazydev.nvim', -- Add lazydev for better code completion
    },
    config = function()
      -- =============================================================================
      -- MASON SETUP: External LSP server manager
      -- =============================================================================
      require('mason').setup {
        ui = {
          -- Nice UI for Mason installation window
          border = 'rounded',
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }

      -- Configure Mason to automatically install LSP servers
      require('mason-lspconfig').setup {
        -- Auto-install these LSP servers
        ensure_installed = {
          'rust_analyzer', -- Rust language support
          'lua_ls', -- Lua language support (for Neovim config)
          'pyright', -- Python language support
          'marksman', -- Markdown support
        },
        -- Automatically setup installed servers
        automatic_installation = true,
      }

      -- =============================================================================
      -- LSP CAPABILITIES: Enhanced features for nvim-cmp integration
      -- =============================================================================
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Additional enhancements for better user experience
      capabilities.textDocument.completion.completionItem = {
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = { 'documentation', 'detail', 'additionalTextEdits' },
        },
      }

      -- =============================================================================
      -- DIAGNOSTIC CONFIG: How errors and warnings are displayed
      -- =============================================================================
      vim.diagnostic.config {
        virtual_text = {
          prefix = '●', -- Show error icons inline
          spacing = 4,
        },
        signs = true, -- Show icons in gutter
        underline = true, -- Underline erroneous code
        update_in_insert = false, -- Don't update while typing
        severity_sort = true, -- Sort errors by severity
      }

      -- Custom highlight colors for diagnostics
      vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#db4b4b' })
      vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#e0af68' })
      vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#0db9d7' })
      vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#10B981' })

      -- =============================================================================
      -- LSP SERVER CONFIGURATIONS
      -- =============================================================================
      local lspconfig = require 'lspconfig'

      -- Rust Analyzer: Advanced Rust language support
      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = 'clippy', -- Use clippy for additional checks
            },
          },
        },
      }

      -- Lua Language Server: Essential for Neovim configuration
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
              globals = { 'vim' }, -- Recognize Neovim global variables
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true), -- Neovim runtime files
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      }

      -- Marksman: Markdown language server
      lspconfig.marksman.setup {
        capabilities = capabilities,
      }

      -- =============================================================================
      -- KEYMAPS: Essential LSP navigation and actions
      -- =============================================================================
      local keymap = vim.keymap.set

      -- Show documentation on hover
      keymap('n', 'K', vim.lsp.buf.hover, { desc = 'Show documentation' })

      -- Navigation
      keymap('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      keymap('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
      keymap('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
      keymap('n', 'gr', vim.lsp.buf.references, { desc = 'Show references' })

      -- Code actions
      keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
      keymap('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })

      -- Diagnostic navigation
      keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
      keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
      keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic details' })

      -- =============================================================================
      -- AUTOCMDS: Enhanced LSP experience
      -- =============================================================================
      local augroup = vim.api.nvim_create_augroup('LspConfig', { clear = true })

      -- Highlight symbol under cursor
      vim.api.nvim_create_autocmd('LspAttach', {
        group = augroup,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.supports_method 'textDocument/documentHighlight' then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = args.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = args.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Format on save for specific filetypes
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        callback = function()
          vim.lsp.buf.format { async = false }
        end,
      })
    end,
  },
}
