return {{
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({
            check_ts = true, -- enable Treesitter integration
            disable_filetype = {"TelescopePrompt", "vim"}
        })

        -- Optional: integrate with nvim-cmp if you use it
        local cmp_ok, cmp = pcall(require, "cmp")
        if cmp_ok then
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    end
}}
