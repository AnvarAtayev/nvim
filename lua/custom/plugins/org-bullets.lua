return {{
    'akinsho/org-bullets.nvim',
    event = 'BufReadPre *.org', -- lazy-load for org files
    config = function()
        require('org-bullets').setup {}
    end
}}
