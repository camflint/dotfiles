-- Appearance.
vim.opt.termguicolors = true

-- Line numbering.
vim.opt.nu = true
vim.opt.relativenumber = true

-- Whitespace and indentation options.
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:2'
vim.opt.showbreak = '↳'

vim.opt.fixeol = false

-- Folding (see also ../../after/plugin/ufo.lua).
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99 -- ufo provider needs a large value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Backspace (always delete previous word).
vim.opt.backspace = 'indent,eol,start'

-- Backup options.
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

-- Search options.
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

local autocmd = vim.api.nvim_create_autocmd

-- Only enable 'hlsearch' when focused on the command line.
autocmd('CmdlineEnter', {
    group = Camflint_Search,
    pattern = '/,?',
    callback = function()
        vim.opt.hlsearch = true
    end
})
autocmd('CmdlineLeave', {
    group = Camflint_Search,
    pattern = '/,?',
    callback = function()
        vim.opt.hlsearch = false
    end
})

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 50
vim.opt.timeoutlen = 500

vim.opt.colorcolumn = '120'

-- Keep the cursor column stable when moving around.
vim.opt.startofline = false

-- Windowing options.

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Diffing.
vim.opt.diffopt = 'internal,filler,vertical,closeoff,algorithm:patience'

