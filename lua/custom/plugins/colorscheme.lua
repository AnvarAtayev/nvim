return {
  {
    'marko-cerovac/material.nvim',
    lazy = false, -- load immediately
    priority = 1000, -- make sure it loads before other plugins
    config = function()
      -- Choose a variant: "darker", "lighter", "oceanic", "palenight", "deep ocean"
      vim.g.material_style = 'deep ocean'

      require('material').setup {
        contrast = {
          terminal = false, -- Enable contrast for the built-in terminal
          sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
          floating_windows = true, -- Enable contrast for floating windows
          cursor_line = true, -- Enable darker cursor lines
          non_current_windows = true, -- Enable darker non-current windows
        },

        styles = { -- Give comments style such as bold, italic, underline etc.
          comments = { italic = true },
          strings = { bold = true },
          keywords = { underline = true },
          functions = { bold = true, undercurl = true },
          variables = {},
          operators = { bold = true },
          types = { bold = true, italic = true },
        },

        plugins = { -- improves highlights for these plugins
          'gitsigns',
          'nvim-cmp',
          'telescope',
          'which-key',
        },

        lualine_style = 'stealth', -- Lualine theme ( can be 'stealth' or 'default' )
      }

      -- Apply colorscheme
      vim.cmd.colorscheme 'material'
    end,
  },
}
