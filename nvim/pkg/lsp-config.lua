vim.opt.signcolumn = 'yes' -- Reserve space for diagnostic icons
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.ensure_installed({
    'arduino_language_server',
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
    --    'jdtls', -- Java
    'tsserver', -- JavaScript / Typescript
    'kotlin_language_server',
    'marksman',
    'lua_ls',
    'perlnavigator',
    'pylsp',
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
        warn = ' ',
        hint = '⚑',
        info = '🛈'
    }
})

lsp.configure('clangd', {
    cmd = { "clangd", "--fallback-style=Webkit" }
})

lsp.setup()

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


--  ╭─────────────────────────────────────────────╮
--  │   Language Server Protocol Configurations   │
--  ╰─────────────────────────────────────────────╯

-- gi: Lists all the implementations for the symbol under the cursor in the quickfix window.
-- See :help vim.lsp.buf.implementation().
-- go: Jumps to the definition of the type of the symbol under the cursor.
-- See :help vim.lsp.buf.type_definition().
-- gr: Lists all the references to the symbol under the cursor in the quickfix window.
-- See :help vim.lsp.buf.references().
-- Go to reference Ctrl + ]
--  ╭────────────────╮
--  │ Code Formatter │
--  ╰────────────────╯
vim.keymap.set("n", "<A-f>", ":lua vim.lsp.buf.format() <CR>")
-- Code actions
vim.keymap.set("n", "<A-q>", ":lua vim.lsp.buf.code_action() <CR>")
-- Bulk rename
vim.keymap.set("n", "<A-r>", ":lua vim.lsp.buf.rename() <CR>")
--Coc Diagnostic Menu
vim.keymap.set("n", "<C-d>", ":lua vim.diagnostic.open_float() <CR>")
vim.keymap.set("n", "<A-d>", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<A-D>", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })

