return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      '  ⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣾⣿⣿⣶⣤⣄⠀⠀⠀⠀⠀⠀',
      '  ⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀',
      '   Welcome to Neovim',
    }

    dashboard.section.buttons.val = {
      dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('f', '󰈞  Find file', ':Telescope find_files<CR>'),
      dashboard.button('r', '  Recent files', ':Telescope oldfiles<CR>'),
      dashboard.button('q', '  Quit', ':qa<CR>'),
    }

    alpha.setup(dashboard.config)

    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
        local bufname = vim.api.nvim_buf_get_name(0)

        if buftype == '' and bufname == '' then
          alpha.start()
        end
      end,
    })
  end,
}
