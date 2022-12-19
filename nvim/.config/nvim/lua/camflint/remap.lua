vim.g.mapleader = '\\'
vim.g.maplocalleader = ','

-- Suspending vim.
vim.keymap.set('n', 'Z', function()
    -- If vim-autosave is installed, invoke it.
    vim.cmd([[
        if exists(':AutoSaveNow')
           execute('AutoSaveNow')
        endif
    ]])
    vim.cmd.suspend()
end)

-- Lazy command line.
vim.keymap.set('n', ';', ':')

-- File explorer.
vim.keymap.set('n', '<leader>e', vim.cmd.Ex)
vim.keymap.set('n', '-', vim.cmd.Vifm)
vim.g.vifm_replace_netrw = 1

-- Folding...

-- Automatically unfold to cursor when searching forward/backward.
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Close all folds except under the cursor.
vim.keymap.set('n', '<localleader>zm', 'zMzvzz')

-- Copy & paste...

-- Yank to-and-from system clipboard.
vim.keymap.set({'n', 'v'}, '<localleader>yy', [['+y]])
vim.keymap.set('n', '<localleader>YY', [['+Y]])
vim.keymap.set('n', '<localleader>pp', [['+p]])

-- Yank the current buffer absolute path.
vim.keymap.set('n', '<localleader>yb', [[:let @+=expand('%:p')<cr>]])

-- Black-hole delete.
vim.keymap.set({'n', 'v'}, '<localleader>d', [['_d]])

-- Visual selection...

-- Select only text and not prefix/suffix whitespace (contrast with V).
vim.keymap.set('n', 'vv', '^v$')

-- Find and replace...

-- Use very-magic search mode, so regular expressions are more intuitive.
vim.keymap.set({'n', 'v'}, '/', [[/\v]])

-- Quickly clear highlighting and close the {quickfix, location} windows.
vim.keymap.set('n', '<localleader>l', function()
	vim.cmd.noh()
	vim.cmd.cclose()
	vim.cmd.lclose()
end)

-- Buffer management...

-- Window and split management...
vim.keymap.set('n', '<localleader>s-', '<C-w>s<C-w>j')       -- split horiz
vim.keymap.set('n', '<localleader>s<pipe>', '<C-w>v<C-w>l')  -- split vert
vim.keymap.set('n', '<localleader>sx', '<C-w>q')             -- close this window
vim.keymap.set('n', '<localleader>so', '<C-w>o')             -- close others
vim.keymap.set('n', '<localleader>sr', '<C-w>r')             -- rotate windows
vim.keymap.set('n', '<localleader>s=', [[:set equalalways<cr> \| <C-w>= \| :set noequalalways<cr>]]) -- distribute window sizes

-- Quickfix.
vim.keymap.set('n', ']q', vim.cmd.cnext)
vim.keymap.set('n', '[q', vim.cmd.cprev)

-- Coding.
vim.keymap.set('n', '<F5>', ':make<cr><cr><cr>')

-- Readline-style keymaps in the command line (from rsi.vim).
vim.keymap.set({'c', 'n'}, '<C-a>', '<Home>')
vim.keymap.set({'c', 'n'}, '<C-b>', '<Left>')
