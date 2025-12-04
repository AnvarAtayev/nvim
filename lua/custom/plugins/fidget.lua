-- lua/custom/plugins/fidget.lua
return {
  'j-hui/fidget.nvim',
  opts = {
    notification = {
      window = {
        align = 'top',         -- Move notifications to top-right
        x_padding = 1,         -- Add a little padding from the right edge
        y_padding = 1,         -- Add a little padding from the top edge
        winblend = 0,          -- Ensure background is solid (readable)
      },
    },
  },
}