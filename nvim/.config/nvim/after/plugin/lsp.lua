vim.opt.signcolumn = 'yes' -- Reserve space for diagnostic sign_icons

local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
	'bashls',
	'html',
	'cssls',
	'eslint',
	'tsserver',
	'jsonls',
	'yamlls',
	'sqlls',
	'pylsp',
	'perlnavigator',
	'sumneko_lua',
	'vimls',
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    set_lsp_keymaps = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  if client.name == 'eslint' then
      vim.cmd.LspStop('eslint')
      return
  end

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gR', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gA', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gF', vim.lsp.buf.format, opts)
  vim.keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
  --vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '[e', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', ']e', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('i', '<F1>', vim.lsp.buf.signature_help, opts)
end)

lsp.nvim_workspace()

lsp.setup()

--vim.diagnostic.config({
--    virtual_text = true,
--})
