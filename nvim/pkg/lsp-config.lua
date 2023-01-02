vim.opt.signcolumn = 'yes' -- Reserve space for diagnostic icons
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.ensure_installed({
    'arduino_language_server',
    'bashls',
    'clangd',
    'cmake',
    'cssls',
    'eslint',
    'diagnosticls',
    'gopls',
    'grammarly',
    'jsonls',
    'jdtls', -- Java
    'tsserver', -- JavaScript / Typescript
    'kotlin_language_server',
    'marksman',
    'sumneko_lua',
    'perlnavigator',
    'jedi_language_server',
    'rust_analyzer',
    'yamlls',
})

lsp.nvim_workspace()
lsp.set_preferences({
    suggest_lsp_servers = true,
    setup_servers_on_start = true,
    set_lsp_keymaps = true,
    configure_diagnostics = true,
    cmp_capabilities = true,
    manage_nvim_cmp = true,
    call_servers = 'local',
    sign_icons = {
        error = '⊗',
        warn = '⚠',
        hint = '⚑',
        info = '🛈'
    }
})

lsp.setup()
