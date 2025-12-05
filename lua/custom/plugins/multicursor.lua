-- lua/custom/plugins/multicursor.lua
return {
  'mg979/vim-visual-multi',
  branch = 'master',
  init = function()
    -- Disable default mappings to prevent conflicts
    vim.g.VM_default_mappings = 0

    -- Define your custom VS Code-like mappings
    vim.g.VM_maps = {
      -- "Select Next Occurrence" (VS Code: Ctrl+d)
      ['Find Under'] = '<C-d>',           
      
      -- "Add Cursor Down" (VS Code: Ctrl+Alt+Down)
      -- NOTE: In terminal, Ctrl+Alt is often just <M-C-...> or sometimes impossible 
      -- to distinguish. <M-C-j> is the vim notation for Alt+Ctrl+j.
      -- If your terminal sends standard codes, <M-C-Down> should work.
      ['Select Cursor Down'] = '<M-C-Down>', 
      ['Select Cursor Up']   = '<M-C-Up>',   
    }
  end,
}