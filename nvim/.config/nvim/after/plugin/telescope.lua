local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

telescope.setup {
    defaults = {
        mappings = {
            i = {
                -- Immediately exist upon <ESC> rather than switching modes.
                ["<esc>"] = actions.close,
            },
        },
        file_ignore_patterns = {
            "dist/.*",
            "node_modules/.*",
            "%.git/.*",
            "%.vim/.*",
            "%.idea/.*",
            "%.vscode/.*",
            "%.history/.*",
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",
            "--smart-case"
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
        frecency = {
            ignore_patterns = { '*.git/*', '*node_modules/*' },
            workspaces = {
                ['home'] = vim.fn.expand('~'),
                ['downloads'] = vim.fn.expand('~/Downloads'),
                ['desktop'] = vim.fn.expand('~/Desktop'),
                ['dotfiles'] = vim.fn.expand('~/code/camflint/dotfiles'),
                ['conf'] = vim.fn.expand('~/.config'),
                ['data'] = vim.fn.expand('~/.local/share'),
            },
            default_workspace = 'CWD',
        },
    },
}

local theme = themes.get_ivy()
vim.keymap.set('n', '<leader>f', function() builtin.find_files(
        vim.tbl_extend('force', theme, {
            hidden = true,
        })
    )
end, {})
vim.keymap.set('n', '<leader>r', function() telescope.extensions.frecency.frecency(theme) end, {})
vim.keymap.set('n', '<leader>g', function() builtin.live_grep(theme) end, {})
vim.keymap.set('n', '<leader>b', function() builtin.buffers(
        vim.tbl_extend('force', theme, {
            sort_lastused = true,
        })
    )
end, {})
vim.keymap.set('n', '<leader>q', function() builtin.quickfix(theme) end, {})
vim.keymap.set('n', '<leader>m', function() builtin.marks(theme) end, {})
vim.keymap.set('n', '<C-p>', function() builtin.git_files(theme) end, {})
vim.keymap.set('n', '<M-o>', function() builtin.lsp_workspace_symbols(theme) end, {})
vim.keymap.set('n', 'K', function() builtin.grep_string(theme) end, {})
--vim.keymap.set('n', '<leader>m', builtin.man_pages, {})

-- Load plugins.
telescope.load_extension('fzf')
telescope.load_extension('frecency')
