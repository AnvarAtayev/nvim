return {{
    'alexanderbluhm/black.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.background = "dark"
        vim.cmd("colorscheme black")

        -- HYPER TERM BLACK PALETTE
        local ht = {
            bg = "#000000",
            fg = "#A6B2C0", -- Text (White/Grey)
            cursor = "#14FA50", -- Green Cursor
            line_nr = "#495162",
            comment = "#5C6370",

            cyan = "#52ADF2", -- Functions
            purple = "#D55FDE", -- Keywords
            green = "#89CA78", -- Strings
            red = "#EF596F", -- Properties / Fields (The "Hyper Red")
            orange = "#D8985F", -- Numbers / Constants
            yellow = "#e5c07b", -- Types
            teal = "#2BBAC5", -- Operators

            guide = "#3B4048",
            selection = "#484e5b"
        }

        local hl = vim.api.nvim_set_hl

        -- 1. UI OVERRIDES (Force Pitch Black)
        hl(0, "Normal", {
            bg = ht.bg,
            fg = ht.fg
        })
        hl(0, "NormalFloat", {
            bg = ht.bg,
            fg = ht.fg
        })
        hl(0, "Cursor", {
            bg = ht.cursor,
            fg = ht.bg
        })
        hl(0, "TermCursor", {
            bg = ht.cursor,
            fg = ht.bg
        })
        hl(0, "LineNr", {
            bg = ht.bg,
            fg = ht.line_nr
        })
        hl(0, "CursorLineNr", {
            bg = ht.bg,
            fg = ht.cursor,
            bold = true
        })
        hl(0, "SignColumn", {
            bg = ht.bg
        })
        hl(0, "VertSplit", {
            fg = ht.guide,
            bg = ht.bg
        })
        hl(0, "WinSeparator", {
            fg = ht.guide,
            bg = ht.bg
        })
        hl(0, "Visual", {
            bg = ht.selection
        })

        -- 2. SYNTAX HIGHLIGHTING
        hl(0, "Comment", {
            fg = ht.comment,
            italic = true
        })
        hl(0, "String", {
            fg = ht.green
        })
        hl(0, "Function", {
            fg = ht.cyan
        })
        hl(0, "Keyword", {
            fg = ht.purple
        })
        hl(0, "Statement", {
            fg = ht.purple
        })
        hl(0, "Operator", {
            fg = ht.teal
        })
        hl(0, "Type", {
            fg = ht.yellow
        })
        hl(0, "Number", {
            fg = ht.orange
        })
        hl(0, "Boolean", {
            fg = ht.orange
        })
        hl(0, "Constant", {
            fg = ht.orange
        })
        hl(0, "Special", {
            fg = ht.purple
        })

        -- 3. THE "HYPER" FIX (Variables White, Properties Red)

        -- Variables are White (matches `ht`, `vim` in your screenshot)
        hl(0, "Identifier", {
            fg = ht.fg
        })
        hl(0, "@variable", {
            fg = ht.fg
        })
        hl(0, "@variable.builtin", {
            fg = ht.fg
        }) -- Ensures 'vim' is white

        -- Table Keys & Fields are Red (matches `bg =`, `fg =` in your screenshot)
        hl(0, "@property", {
            fg = ht.red
        })
        hl(0, "@field", {
            fg = ht.red
        })
        hl(0, "@variable.member", {
            fg = ht.red
        }) -- Modern treesitter capture for fields

        -- 4. NEO-TREE MATCHING (Fixing the Sidebar)
        -- Force sidebar background to Black and text to White
        hl(0, "NeoTreeNormal", {
            bg = ht.bg,
            fg = ht.fg
        })
        hl(0, "NeoTreeNormalNC", {
            bg = ht.bg,
            fg = ht.fg
        })
        hl(0, "NeoTreeDirectoryName", {
            fg = ht.fg
        }) -- Folders are White
        hl(0, "NeoTreeDirectoryIcon", {
            fg = ht.fg
        }) -- Folder icons are White
        hl(0, "NeoTreeFileName", {
            fg = ht.fg
        }) -- Files are White
        hl(0, "NeoTreeRootName", {
            fg = ht.purple,
            bold = true
        })
        hl(0, "NeoTreeWinSeparator", {
            link = "WinSeparator"
        })

        -- Git Status Colors (Matches VS Code Sidebar)
        hl(0, "NeoTreeGitModified", {
            fg = ht.yellow
        })
        hl(0, "NeoTreeGitUntracked", {
            fg = ht.green
        })
        hl(0, "NeoTreeGitDeleted", {
            fg = ht.red
        })
        hl(0, "NeoTreeGitIgnored", {
            fg = ht.comment
        })

        -- 5. TELESCOPE MATCHING
        hl(0, "TelescopeNormal", {
            bg = ht.bg
        })
        hl(0, "TelescopeBorder", {
            bg = ht.bg,
            fg = ht.guide
        })
        hl(0, "TelescopePromptNormal", {
            bg = ht.bg
        })
        hl(0, "TelescopeTitle", {
            fg = ht.cyan,
            bold = true
        })
    end
}}
