vim.opt.signcolumn = 'yes' -- Reserve space for diagnostic icons
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({
        buffer = bufnr,
        preserve_mappings = false
    })
end)

lsp.ensure_installed({
    'bashls',
    'clangd',
    'cmake',
    'cssls',
    'dockerls',
    'docker_compose_language_service',
    'eslint',
    'diagnosticls',
    'gopls',
    'grammarly',
    'html',
    'jsonls',
    'jdtls',    -- Java
    'tsserver', -- JavaScript / Typescript
    'marksman',
    'lua_ls',
    'perlnavigator',
    'pylsp',
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
        warn = ' ',
        hint = '⚑',
        info = '🛈'
    }
})

lsp.configure('clangd', {
    cmd = { "clangd", "--fallback-style=Webkit" }
})

lsp.setup()
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    mapping = {
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    }
})


vim.diagnostic.config({
    --    virtual_text = true,
    virtual_text = {
        prefix = ' ',
        spacing = 0,
    },
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = false,
    --  {
    --      focusable = true,
    --      style = 'minimal',
    --      border = 'rounded',
    --      source = 'always',
    --      header = '',
    --      prefix = '',
    --  },
})


--  ╭──────────────────────────╮
--  │ Treesitter Language List │
--  ╰──────────────────────────╯

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c",
        "cmake",
        "comment",
        "cpp",
        "dockerfile",
        "go",
        "gomod",
        "gdscript",
        "html",
        "http",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "kotlin",
        "latex",
        "lua",
        "make",
        "perl",
        "python",
        "regex",
        "ruby",
        "rust",
        "scheme",
        "scss",
        "svelte",
        "todotxt",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vue",
        "yaml",
    },
    sync_install = false,
    ignore_install = {},
    highlight = {
        enable = true,
        -- list of language that will be disabled
        disable = {},
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
})


