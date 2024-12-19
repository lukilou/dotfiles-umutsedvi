-------------------------------------------------------------------------------
-- File: init.lua
--
-- Author: Umut Sevdi
-- Created: 04/07/22
-- Description: init.lua is the primary configuration file that initializes
-- basic settings and initializes basic Lua configurations.
-- It also links the configuration files of plugins respectively.
-------------------------------------------------------------------------------
vim.cmd([[
    set shell=$SHELL
    set encoding=UTF-8
    syntax on
    set t_Co=256
    set cmdheight=1
    set shortmess+=c
    set showtabline=0
    set foldmethod=manual
    set mousemodel=extend
    set inccommand=nosplit
    set conceallevel=0
    set expandtab
    set smarttab
    set smartindent
    set spell
    set colorcolumn=80
]])
vim.o.termguicolors = false
vim.o.hidden = true
vim.o.updatetime = 200
-- Disable backup files
vim.o.backup = false
vim.o.writebackup = false
vim.o.signcolumn = 'yes'
vim.o.number = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.undodir = "/home/umutsevdi/.config/nvim/undodir"
vim.o.swapfile = false
vim.o.history = 50
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.numberwidth = 6
vim.o.scrolloff = 8
vim.o.wrap = false
vim.o.textwidth = 300
vim.o.list = true
vim.o.jumpoptions = "view"

-- Install Lazy.nvim if not exists
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy').setup({
    'wbthomason/packer.nvim',       -- packer can manage itself
    'lewis6991/gitsigns.nvim',      -- git symbols on the left
    'nvim-lualine/lualine.nvim',    -- bottom bar
    'LudoPinelli/comment-box.nvim', -- comment box
    'm4xshen/autoclose.nvim',
    "rebelot/kanagawa.nvim",
    "folke/trouble.nvim",
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = { "Telescope" },
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        cmd = { "Oil" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    --    { 'junegunn/fzf',                    dir = '~/.fzf',     build = './install --all' },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/cmp-nvim-lsp' },

            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { "L3MON4D3/LuaSnip" },
            { 'hrsh7th/nvim-cmp' },
            { 'saadparwaiz1/cmp_luasnip' },
            { "rafamadriz/friendly-snippets" }, -- provides snippets
        }
    },
})
IS_WINDOWS = vim.fn.executable("clip.exe") == 1 and true or false

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({
    paths = { "~/.dotfiles/nvim/snippets/" }
})

local cmp = require("cmp")
local luasnip = require("luasnip")
local select_opts = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
    },
    window = {
        documentation = cmp.config.window.bordered()
    },
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon =
                IS_WINDOWS and {
                    nvim_lsp = '⎀',
                    luasnip = '⎓',
                    buffer = '⎙',
                    path = '⌘',
                } or {
                    nvim_lsp = '󰌷',
                    luasnip = '󱡠',
                    buffer = '',
                    path = '',
                }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        ['<C-f>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-b>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
})

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

require('mason').setup {}
require('mason-lspconfig').setup {
    ensure_installed = {
        'bashls', 'clangd', 'cssls', 'lua_ls',
        'gopls', 'grammarly', 'html', 'marksman',
        'pylsp', 'ts_ls' --, 'cmake'
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup {
            }
        end,
    }
}

require('lspconfig').lua_ls.setup({
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or
                vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force',
            client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT'
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                }
            })
    end,
    settings = {
        diagnostics = { globals = { "vim" } }
    }
})

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    ensure_installed = {
        "c", "cmake", "comment", "cpp", "dart", "dockerfile", "go", "gomod",
        "gdscript", "html", "http", "java", "javascript", "jsdoc", "json",
        "lua", "make", "perl", "python", "regex", "rust", "toml",
        "tsx", "typescript", "yaml", "vim", "vimdoc" },
})

require('kanagawa').setup({
    compile = true,   -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = { bold = true, italic = true },
    keywordStyle = { italic = false, bold = true },
    statementStyle = {},
    typeStyle = { bold = true },
    transparent = true,    -- do not set background color
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    background = {         -- map the value of 'background' option to a theme
        dark = "dragon",   -- try "dragon" !
        light = "lotus"
    },
})
vim.cmd("colorscheme kanagawa")

require("lualine").setup({
    options = {
        theme = '16color',
    },
    sections = {
        lualine_a = { "mode", "branch" },
        lualine_b = {
            {
                "filename",
                symbols = {
                    modified = " * ",
                    readonly = "  ",
                    unnamed = "[No Name]",
                },
            },
        },
        lualine_c = {},
        lualine_x = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic", "nvim_lsp" },
                sections = { "error", "warn", "info", "hint" },
                symbols = {
                    error = " ⊗ ",
                    warn = " ",
                    info = "🛈 ",
                    hint = "⚑ "
                },
            },
        },
        lualine_y = { "tabs", "location" },
        lualine_z = { "encoding", "filetype" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'filetype', 'filename' }
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
})

require("trouble").setup {
    warn_no_results = true,
    open_no_results = true,
    focus = true,
    modes = {
        workspace_diagnostics = {
            mode = "diagnostics", -- inherit from diagnostics mode
            filter = {
                any = {
                    buf = 0, {
                    severity = { min = vim.diagnostic.severity.WARN },
                    function(item)
                        return item.filename:find((vim.loop or vim.uv).cwd(),
                            1, true)
                    end,
                } } },
        }
    }
}

require('telescope').setup {
    pickers = {
        find_files = { theme = "dropdown" },
        treesitter = { theme = "dropdown" },
        buffers = { theme = "dropdown" },
        help_tags = { theme = "dropdown" }
    },
}

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "⊗",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "⚑",
            [vim.diagnostic.severity.INFO]  = "🛈",
        }
    },
    virtual_text = true,
})

require('gitsigns').setup {
    signs              = {
        add          = { text = '┃' },
        change       = { text = '┇' },
        delete       = { text = '╴' },
        topdelete    = { text = '╸' },
        changedelete = { text = '╍' },
        untracked    = { text = '┊' },
    },
    current_line_blame = true,
    signcolumn         = true,
    numhl              = false,
    linehl             = false,
    word_diff          = false,
    watch_gitdir       = {
        interval = 1000,
        follow_files = true
    },
}
--  ┌─────────────┐
--  │ Keybindings │
--  └─────────────┘
require("autoclose").setup()
vim.cmd([[
    map <silent> <A-h> :tabprevious<CR>
    map <silent> <A-l> :tabnext<CR>
    map <silent> <A-Left> :tabprevious<CR>
    map <silent> <A-Right> :tabnext<CR>
    map <silent> <A-1> :tabfirst <cr>
    map <silent> <A-0> :tablast<cr>
]])
vim.keymap.set("n", "qq", ":q! <CR>")
vim.keymap.set("n", "<A-n>", ":tabnew | Oil <CR>")
vim.keymap.set("n", "<A-t>", ":vsplit | Oil <CR>")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- ╭───────────╮
-- │ Telescope │
-- ╰───────────╯
vim.keymap.set("n", "ff", ":Telescope find_files <CR>")
vim.keymap.set("n", "fs", ":Telescope live_grep <CR>")
vim.keymap.set("n", "fd", ":Telescope lsp_references <CR>")
vim.keymap.set("n", "fg", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "fh", "<cmd>Telescope man_pages sections=2,3<CR>")
--  ╭─────────────────────────────────────────────╮
--  │   Language Server Protocol Configurations   │
--  ╰─────────────────────────────────────────────╯
vim.keymap.set("n", "<A-f>", ":lua vim.lsp.buf.format() <CR>")
vim.keymap.set("n", "<A-q>", ":lua vim.lsp.buf.code_action() <CR>")
vim.keymap.set("n", "<A-r>", ":lua vim.lsp.buf.rename() <CR>")
vim.keymap.set("n", "<A-d>", "<cmd>Trouble workspace_diagnostics toggle<CR>",
    { silent = true, noremap = true })

if IS_WINDOWS then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
else
    local function getColor()
        local handle = io.popen(
            "/usr/bin/gsettings get org.gnome.desktop.interface color-scheme")
        if handle == nil then
            return false
        end
        local result = handle:read("*a") -- Read all output
        handle:close()
        return string.find(result, "prefer-dark", 1, true) ~= nil
    end
    function SetColors()
        if getColor() then
            vim.cmd [[ set background=dark ]]
        else
            vim.cmd [[ set background=light ]]
        end
    end

    SetColors()
end
