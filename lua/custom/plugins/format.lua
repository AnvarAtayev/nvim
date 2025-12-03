return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },

    -- Add keybinding to format the current buffer
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    config = function()
      local conform = require 'conform'

      conform.setup {
        formatters_by_ft = {
          rust = { 'rustfmt' },
          lua = { 'stylua' },
          python = { 'ruff_format' },
          -- Conform can also run multiple formatters sequentially
          -- python = { "isort", "black" },
          --
          -- You can use a sub-list to tell conform to run *until* a formatter
          -- is found.
          -- javascript = { { "prettierd", "prettier" } },
        },

        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true }
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          else
            return {
              timeout_ms = 500,
              lsp_fallback = 'fallback',
            }
          end
        end,
        notify_on_error = false,
      }

      -- Register the :Format command
      vim.api.nvim_create_user_command('Format', function()
        conform.format { async = false }
      end, {})
    end,
  },
}
