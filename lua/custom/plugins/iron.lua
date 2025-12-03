return {
  {
    'Vigemus/iron.nvim',
    config = function()
      local iron = require 'iron.core'

      iron.setup {
        config = {
          repl_definition = {
            python = { command = { 'python3' } },
          },
          repl_open_cmd = 'vertical botright 60 split',
        },
        keymaps = {
          send_motion = '<leader>sc',
          visual_send = '<leader>sc',
          send_line = '<leader>sl',
          send_file = '<leader>sf',
          cr = '<leader>s<cr>',
          interrupt = '<leader>si',
          exit = '<leader>sq',
          clear = '<leader>cl',
        },
      }

      -- Example keymaps
      vim.keymap.set('n', '<leader>rs', '<cmd>IronRepl<cr>', { desc = 'Start REPL' })
      vim.keymap.set('n', '<leader>rr', '<cmd>IronRestart<cr>', { desc = 'Restart REPL' })
      vim.keymap.set('n', '<leader>rl', '<cmd>IronFocus<cr>', { desc = 'Focus REPL' })
      vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = 'Hide REPL' })
    end,
  },
}
