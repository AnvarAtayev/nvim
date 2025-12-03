-- lua/custom/plugins/venv-selector.lua
return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  lazy = false,
  branch = 'main',
  config = function()
    require('venv-selector').setup({})
  end,
  keys = {
    { ',v', '<cmd>VenvSelect<cr>' },
  },
}
