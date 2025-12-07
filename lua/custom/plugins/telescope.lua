return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {'nvim-lua/plenary.nvim', {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end
    }, {'nvim-telescope/telescope-ui-select.nvim'}, {'nvim-tree/nvim-web-devicons'}},
    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')

        -----------------------------------------------------------------------
        -- 1. DEFINE SYSTEM JUNK
        -----------------------------------------------------------------------
        local global_ignore = {"**/Library/**", "**/Applications/**", "**/Music/**", "**/Movies/**", "**/Pictures/**",
                               "**/Zotero/**", "**/Downloads/**", "**/.Trash/**", "**/.cache/**", "**/.local/**",
                               "**/.config/**", "**/ntws/**", "**/.git/**", "**/node_modules/**", "**/.vscode/**",
                               "**/__pycache__/**", "**/venv/**", "**/.cargo/**", "**/.rustup/**", "**/.tldrc/**",
                               "**/.zsh_sessions/**", "*.png", "*.jpg", "*.jpeg", "*.svg", "*.gif", "*.webp", "*.mp4",
                               "*.mp3", "*.wav", "*.mkv", "*.mov", "*.flac", "*.ico", "*.icns", "*.pdf", "*.zip",
                               "*.tar", "*.gz", "*.7z", "*.rar", "*.dmg", "*.data", "*.lock", "*.woff", "*.woff2"}

        -----------------------------------------------------------------------
        -- 2. BUILD THE SEARCH COMMAND
        -----------------------------------------------------------------------
        local function get_global_search_cmd()
            local cmd = {"rg", "--files", "--smart-case"}
            for _, pattern in ipairs(global_ignore) do
                table.insert(cmd, "--glob")
                table.insert(cmd, "!" .. pattern)
            end
            return cmd
        end

        -----------------------------------------------------------------------
        -- 3. SETUP TELESCOPE
        -----------------------------------------------------------------------
        telescope.setup({
            defaults = {
                -- VISUALS: Filename First
                -- This shows: "init.lua   lua/telescope/init.lua"
                path_display = {"filename_first"},

                file_ignore_patterns = {"%.pdf", "%.png", "%.jpg", "%.zip", "%.exe", "%.parquet", "%.h5", "%.db",
                                        "%.sqlite"},

                layout_strategy = 'horizontal',
                layout_config = {
                    prompt_position = "top"
                },
                sorting_strategy = "ascending"
            },
            extensions = {
                fzf = {
                    fuzzy = false,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case"
                },
                ['ui-select'] = {require('telescope.themes').get_dropdown()}
            }
        })

        -- Enable Extensions
        pcall(telescope.load_extension, 'fzf')
        pcall(telescope.load_extension, 'ui-select')

        -- KEYMAPS
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, {
            desc = '[S]earch [H]elp'
        })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, {
            desc = '[S]earch [K]eymaps'
        })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, {
            desc = '[S]earch [F]iles'
        })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, {
            desc = '[S]earch [S]elect Telescope'
        })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, {
            desc = '[S]earch current [W]ord'
        })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, {
            desc = '[S]earch by [G]rep'
        })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, {
            desc = '[S]earch [D]iagnostics'
        })
        vim.keymap.set('n', '<leader>sr', builtin.resume, {
            desc = '[S]earch [R]esume'
        })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, {
            desc = '[S]earch Recent Files'
        })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, {
            desc = '[ ] Find existing buffers'
        })

        -- Buffer Fuzzy Find
        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false
            })
        end, {
            desc = '[/] Fuzzily search in current buffer'
        })

        -- Config Search
        vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files {
                cwd = vim.fn.stdpath 'config'
            }
        end, {
            desc = '[S]earch [N]eovim files'
        })

        -- Ctrl + P : Global file search (No Preview, Fast)
        vim.keymap.set('n', '<C-p>', function()
            builtin.find_files({
                cwd = vim.fn.expand("~"),
                find_command = get_global_search_cmd(),
                previewer = false
            })
        end, {
            desc = 'Global Search (Home)'
        })

        -- Ctrl + Shift + P : Command Palette
        vim.keymap.set('n', '<C-S-p>', builtin.commands, {
            desc = 'Command Palette'
        })

        -- Open folder function
        local function open_folder()
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            builtin.find_files({
                prompt_title = "Open Folder",
                cwd = vim.fn.expand("~"), -- Start searching from Home
                
                -- COMMAND: Use 'fd' to list directories only
                -- --type d : Directories only
                -- --max-depth 4 : Don't go too deep (speed)
                -- --hidden : Find .config, .local, etc
                find_command = { 
                    "fd", "--type", "d", "--hidden", "--max-depth", "4",
                    "--exclude", ".git",  "--exclude", "node_modules",
                    "--exclude", "Library", "--exclude", "Music",
                    "--exclude", "Movies", "--exclude", "Pictures"
                },
                
                attach_mappings = function(prompt_bufnr, map)
                    -- Overwrite <CR> to 'cd' instead of 'edit'
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        
                        if selection then
                            -- Construct full path (Home + Relative Path)
                            local full_path = vim.fn.expand("~") .. "/" .. selection[1]
                            
                            -- Change Directory
                            vim.api.nvim_set_current_dir(full_path)
                            print("Opened: " .. full_path)
                            
                            -- Optional: Immediately open file search in new project
                            -- builtin.find_files({ cwd = full_path }) 
                        end
                    end)
                    return true
                end,
                previewer = false,
            })
        end

        -- Ctrl + O : Open Folder Picker
        vim.keymap.set('n', '<C-o>', open_folder, { desc = 'Open Folder (Change Directory)' })
    end
}
