return {{
    'neovim/nvim-lspconfig',
    dependencies = { -- Automatically install LSPs and related tools to stdpath for Neovim
    {
        'mason-org/mason.nvim',
        opts = {
            ui = {
                -- Nice UI for Mason installation window
                border = 'rounded',
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗'
                }
            }
        }
    }, 'mason-org/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim', 'hrsh7th/cmp-nvim-lsp'},
    config = function()
        -- Brief aside: **What is LSP?**
        --
        -- LSP is an initialism you've probably heard, but might not understand what it is.
        --
        -- LSP stands for Language Server Protocol. It's a protocol that helps editors
        -- and language tooling communicate in a standardized fashion.
        --
        -- In general, you have a "server" which is some tool built to understand a particular
        -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
        -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
        -- processes that communicate with some "client" - in this case, Neovim!
        --
        -- LSP provides Neovim with features like:
        --  - Go to definition
        --  - Find references
        --  - Autocompletion
        --  - Symbol Search
        --  - and more!
        --
        -- Thus, Language Servers are external tools that must be installed separately from
        -- Neovim. This is where `mason` and related plugins come into play.
        --
        -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
        -- and elegantly composed help section, `:help lsp-vs-treesitter`
        -- =============================================================================
        -- MASON SETUP: External LSP server manager
        -- =============================================================================
        -- Configure Mason to automatically install LSP servers
        require('mason-lspconfig').setup {
            -- Auto-install these LSP servers
            ensure_installed = {'rust_analyzer', -- Rust language support
            'lua_ls', -- Lua language support (for Neovim config)
            'pyright', -- Python language support
            'marksman' -- Markdown support
            },
            -- Automatically setup installed servers
            automatic_installation = true
        }

        require('mason-tool-installer').setup {
            ensure_installed = {'stylua' -- Used to format Lua code
            }
        }

        -- =============================================================================
        -- LSP CAPABILITIES: Enhanced features for nvim-cmp integration
        -- =============================================================================
        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim-cmp, and then broadcast that to the servers.
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
            tagSupport = {
                valueSet = {1}
            },
            resolveSupport = {
                properties = {'documentation', 'detail', 'additionalTextEdits'}
            }
        }

        -- =============================================================================
        -- DIAGNOSTIC CONFIG: How errors and warnings are displayed
        -- =============================================================================
        vim.diagnostic.config {
            virtual_text = {
                prefix = '●', -- Show error icons inline
                spacing = 4
            },
            signs = true, -- Show icons in gutter
            underline = true, -- Underline erroneous code
            update_in_insert = false, -- Don't update while typing
            severity_sort = true -- Sort errors by severity
        }

        -- Custom highlight colors for diagnostics
        vim.api.nvim_set_hl(0, 'DiagnosticError', {
            fg = '#db4b4b'
        })
        vim.api.nvim_set_hl(0, 'DiagnosticWarn', {
            fg = '#e0af68'
        })
        vim.api.nvim_set_hl(0, 'DiagnosticInfo', {
            fg = '#0db9d7'
        })
        vim.api.nvim_set_hl(0, 'DiagnosticHint', {
            fg = '#10B981'
        })

        -- =============================================================================
        -- LSP SERVER CONFIGURATIONS
        -- =============================================================================

        -- Rust Analyzer: Advanced Rust language support
        vim.lsp.config('rust_analyzer', {
            capabilities = capabilities,
            settings = {
                ['rust-analyzer'] = {
                    checkOnSave = {
                        command = 'clippy' -- Use clippy for additional checks
                    }
                }
            }
        })
        vim.lsp.enable('rust_analyzer')

        -- Lua Language Server: Essential for Neovim configuration
        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT'
                    },
                    diagnostics = {
                        globals = {'vim'} -- Recognize Neovim global variables
                    },
                    completion = {
                        callSnippet = 'Replace'
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('', true), -- Neovim runtime files
                        checkThirdParty = false
                    },
                    telemetry = {
                        enable = false
                    }
                }
            }
        })
        vim.lsp.enable('lua_ls')

        -- Marksman: Markdown language server
        vim.lsp.config('marksman', {
            capabilities = capabilities
        })
        vim.lsp.enable('marksman')

        -- Pyright (Ensure it is enabled since it is in ensure_installed)
        vim.lsp.config('pyright', { -- or 'basedpyright' if you use that
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = 'workspace'
                    }
                }
            },
            -- Automatically use the .venv in the current directory if it exists
            on_init = function(client)
                local cwd = vim.fn.getcwd()
                local venv_path = cwd .. '/.venv/bin/python'
                if vim.fn.executable(venv_path) == 1 then
                    client.config.settings.python.pythonPath = venv_path
                    client.notify("workspace/didChangeConfiguration", {
                        settings = client.config.settings
                    })
                end
            end
        })
        vim.lsp.enable('pyright')

        -- =============================================================================
        -- ATTACH CONFIG (Keymaps & Autocmds)
        -- =============================================================================
        -- This function gets run when an LSP attaches to a particular buffer.
        -- Every time a new file is opened that is associated with an lsp (e.g. main.rs)
        -- this function will be executed to configure the current buffer.

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', {
                clear = true
            }),
            callback = function(event)
                -- NOTE: Helper function to define mappings specific for LSP related items.
                -- It sets the mode, buffer and description for us each time.
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, {
                        buffer = event.buf,
                        desc = 'LSP: ' .. desc
                    })
                end

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

                -- Find references for the word under your cursor.
                map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map('gt', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

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

                -- Show documentation on hover (similar to hovering mouse in VS Code)
                map('K', vim.lsp.buf.hover, 'Hover Documentation')

                -- Diagnostic navigation
                map('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
                map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
                map('<leader>e', vim.diagnostic.open_float, 'Show Diagnostic Error')

                -- Helper function to check if a client supports a method
                -- This handles differences between Neovim versions (0.10 vs 0.11)
                ---@param client vim.lsp.Client
                ---@param method vim.lsp.protocol.Method
                ---@param bufnr? integer some lsp support methods only in specific files
                ---@return boolean
                local function client_supports_method(client, method, bufnr)
                    if client.supports_method then
                        return client:supports_method(method, bufnr)
                    else
                        return client.supports_method(method, {
                            bufnr = bufnr
                        })
                    end
                end

                local client = vim.lsp.get_client_by_id(event.data.client_id)

                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
                            bufnr = event.buf
                        })
                    end, '[T]oggle Inlay [H]ints')
                end

                -- ROBUST DOCUMENT HIGHLIGHT
                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                if client and
                    client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', {
                        clear = false
                    })

                    -- Checks support at runtime before calling highlight
                    local function safe_document_highlight()
                        vim.lsp.buf.clear_references()
                        local clients = vim.lsp.get_clients({
                            bufnr = event.buf
                        })
                        for _, c in ipairs(clients) do
                            if client_supports_method(c, vim.lsp.protocol.Methods.textDocument_documentHighlight,
                                event.buf) then
                                vim.lsp.buf.document_highlight()
                                return
                            end
                        end
                    end

                    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = safe_document_highlight
                    })

                    vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', {
                            clear = true
                        }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds {
                                group = 'kickstart-lsp-highlight',
                                buffer = event2.buf
                            }
                        end
                    })
                end
            end
        })

        -- Format on save
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('LspFormat', {
                clear = true
            }),
            callback = function()
                vim.lsp.buf.format {
                    async = false
                }
            end
        })

    end
}}
