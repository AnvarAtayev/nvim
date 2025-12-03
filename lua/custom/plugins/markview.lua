return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false, -- Load immediately for better performance
    ft = 'markdown',
    priority = 1000, -- Load markview before other plugins
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons', -- Optional for icons
    },
    config = function()
      require('markview').setup {
        -- Preview configuration (replaces top-level modes, hybrid_modes, callbacks)
        preview = {
          modes = { 'n', 'no', 'c' }, -- Normal, operator-pending, and command-line modes
          hybrid_modes = { 'n' }, -- Hybrid mode for normal mode

          -- Configure callbacks for different modes
          callbacks = {
            on_enable = function(_, win)
              vim.wo[win].conceallevel = 2
              vim.wo[win].concealcursor = 'c'
            end,
          },
        },

        -- LaTeX/Math configuration
        latex = {
          enable = true,
          -- Inline math delimiters (updated from 'inline' to 'inlines')
          inlines = {
            enable = true,
          },
          -- Block math delimiters (updated from 'block' to 'blocks')
          blocks = {
            enable = true,
          },
        },

        -- Inline code configuration
        inline_codes = {
          enable = true,
          corner_left = ' ',
          corner_right = ' ',
          padding_left = ' ',
          padding_right = ' ',
          hl = 'MarkviewInlineCode',
        },

        -- Code block configuration
        code_blocks = {
          enable = true,
          style = 'language',
          border_hl = 'MarkviewCode', -- Updated from 'hl' to 'border_hl'
          min_width = 60,
          pad_amount = 3,
          sign = true,
        },

        -- Markdown-specific configuration
        markdown = {
          -- Heading configuration (moved under markdown)
          headings = {
            enable = true,
            shift_width = 0,
          },

          -- List configuration (moved under markdown)
          list_items = {
            enable = true,
            shift_width = 2,
          },

          -- Tables (moved under markdown)
          tables = {
            enable = true,
            text = {
              '┌',
              '┬',
              '┐',
              '├',
              '┼',
              '┤',
              '└',
              '┴',
              '┘',
              '│',
              '─',
            },
          },
        },

        -- Checkbox configuration
        checkboxes = {
          enable = true,
          checked = {
            text = '✓',
            hl = 'MarkviewCheckboxChecked',
          },
          unchecked = {
            text = '✗',
            hl = 'MarkviewCheckboxUnchecked',
          },
        },

        -- Experimental settings to handle load order
        experimental = {
          check_rtp = false, -- Disable runtime path checking
          check_rtp_message = false, -- Hide the warning message
        },
      }

      -- Keybindings
      vim.keymap.set('n', '<leader>mp', '<cmd>Markview toggle<cr>', { desc = 'Toggle Markview' })
      vim.keymap.set('n', '<leader>ms', '<cmd>Markview splitToggle<cr>', { desc = 'Toggle Markview in split' })
    end,
  },
}
