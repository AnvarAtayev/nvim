-- lua/custom/plugins/mini_config.lua

return {
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
        -- Try to get the venv name from venv-selector
        local venv_path = require('venv-selector').venv()

        if venv_path then
            -- Extract just the name from the path (e.g., ".venv" or "my-env")
            local venv_name = vim.fn.fnamemodify(venv_path, ':t')
            return string.format(' %s | %%2l:%%-2v', venv_name)
        else
            return '%2l:%-2v'
      end
    end

    -- Custom highlight group for modified status (New logic)
    vim.api.nvim_set_hl(0, 'CustomModifiedStatus', { fg = '#FFCC66', bold = true })

    -- Autocommand to apply modified highlight (New logic)
    vim.api.nvim_create_autocmd({ 'BufModifiedSet', 'BufEnter', 'ColorScheme' }, {
      group = vim.api.nvim_create_augroup('CustomModifiedStatusGroup', { clear = true }),
      callback = function(args)
        if vim.bo[args.buf].modified then
          -- Link the MiniStatuslineFilename highlight to our custom highlight
          vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { link = 'CustomModifiedStatus' })
        else
          -- Link it back to the default group when the buffer is clean
          vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { link = 'MiniStatuslineFilenameNormal' })
        end
        vim.cmd 'redrawstatus'
      end,
    })
  end,
}