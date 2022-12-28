-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- VIFM to launch the file explorer inside neovim.
    use 'vifm/vifm.vim'

    -- Autosave to silently back up files when suspending, switching buffers, etc.
    use 'camflint/vim-autosave'

    -- Telescope for fuzzy-finding and quick switching.
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Telescope FZF plugin for faster results filtering.
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Telescope 'frecency' plugin for MRU.
    use {
        'nvim-telescope/telescope-frecency.nvim',
        requires = { 'kkharji/sqlite.lua' }
    }

    -- 'rose-pine' colorscheme
    use {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    }

    -- Treesitter for faster AST-based features like syntax highlighting.
    use {
        'nvim-treesitter/nvim-treesitter',
        as = 'treesitter',
        run = ':TSUpdate'
    }

    -- Zero-config LSP.
    use {
        'VonHeikemen/lsp-zero.nvim',
        as = 'lsp-zero',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    -- Adds LPS-aware folding.
    use {
        'kevinhwang91/nvim-ufo',
        as = 'ufo',
        requires = 'kevinhwang91/promise-async',
        after = { 'lsp-zero', 'treesitter' },
    }

    -- Surround to e.g. replace single-quotes with double-quotes.
    use {
        'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup({})
        end
    }

    -- Autopairs to e.g. insert closing ')', '}' etc.
    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup {} end
    }

    use {
        'ray-x/lsp_signature.nvim',
        as = 'lsp_signature',
        config = function() require('lsp_signature').setup {} end
    }

    -- Comment to comment code.
    use {
        'terrortylor/nvim-comment',
        config = function()
            require('nvim_comment').setup {}
        end
    }

    use {
        'norcalli/nvim-colorizer.lua',
        as = 'colorizer',
        config = function() require('colorizer').setup {} end
    }
end)
