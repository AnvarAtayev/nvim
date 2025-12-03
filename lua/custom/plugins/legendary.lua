return {
  'mrjones2014/legendary.nvim',
  priority = 10000,
  lazy = false,
  dependencies = { 'kkharji/sqlite.lua' },
  keys = {
    { '<leader>p', '<cmd>Legendary<cr>', desc = 'Command Palette' },
    { '<C-S-p>', '<cmd>Legendary<cr>', desc = 'Command Palette' }, -- VSCode-style
  },
  opts = {
    extensions = {
      lazy_nvim = true,
      which_key = {
        auto_register = true,
      },
    },
  },
}
