local ufo = require('ufo')

-- LSP integration.
local cmp = require("cmp_nvim_lsp")
cmp.default_capabilities {
    foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
}

ufo.setup {
    provider_selector = function(bufnr, filetype)
        return { 'lsp', 'indent' }
    end,
}

vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)
