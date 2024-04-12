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
set shiftwidth=4
set expandtab
set smarttab
set smartindent
set spell
set colorcolumn=80
]])
vim.o.termguicolors = true
vim.o.hidden = true
vim.o.updatetime = 200
vim.o.timeoutlen = 500
-- Disable backup files
vim.o.backup = false
vim.o.writebackup = false
vim.o.signcolumn = "yes"
-- show line numbers
vim.o.number = true
vim.o.cursorline = true
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.smartcase = true
-- Undo and backup options
vim.o.undofile = true
vim.o.undodir = "/home/umutsevdi/.config/nvim/undodir"
vim.o.swapfile = false
vim.o.history = 50
vim.o.splitright = true
vim.o.splitbelow = true
-- whitespace configuration
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
-- Better editor UI
vim.o.numberwidth = 6
vim.o.scrolloff = 8
vim.o.wrap = true
vim.o.textwidth = 300
vim.o.list = true
vim.o.jumpoptions = "view"
-- Last status = 0, removes the bottom line text after running a command
vim.o.ls = 0
vim.o.ch = 1

--  ╭────────────────╮
--  │     Plugins    │
--  ╰────────────────╯

vim.cmd [[packadd packer.nvim]]
require('packer').startup({
    function(use)
        use 'wbthomason/packer.nvim'  -- packer can manage itself
        use 'lewis6991/gitsigns.nvim' -- git symbols on the left
        use {
            'nvim-telescope/telescope.nvim',
            requires = { 'nvim-lua/plenary.nvim' },
        } -- fzf extension that displays preview
        use {
            'nvim-tree/nvim-tree.lua',
            requires = { 'nvim-tree/nvim-web-devicons' },
        }
        use 'nvim-lualine/lualine.nvim'    -- bottom bar
        use 'LudoPinelli/comment-box.nvim' -- comment box
        use "rebelot/kanagawa.nvim"
        use 'm4xshen/autoclose.nvim'
        use "folke/trouble.nvim"
        use { 'junegunn/fzf',
            dir = '~/.fzf',
            run = './install --all'
        } -- fzf
        use { 'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate'
        }
        use {
            "iamcco/markdown-preview.nvim",
            run = function() vim.fn["mkdp#util#install"]() end,
        }
        use { 'michaelb/sniprun', run = 'bash install.sh' }
        use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v3.x',
            requires = {
                { 'williamboman/mason.nvim' },
                { 'williamboman/mason-lspconfig.nvim' },
                -- LSP Support
                { 'neovim/nvim-lspconfig' },
                -- Snippets
                { 'hrsh7th/nvim-cmp' },
                { 'saadparwaiz1/cmp_luasnip' },
                { 'hrsh7th/cmp-nvim-lsp' },

                { 'L3MON4D3/LuaSnip' },
                { 'honza/vim-snippets' },
                { 'rafamadriz/friendly-snippets' },
            }
        }
    end,
    config = {
        max_jobs = 30,
        auto_reload_compiled = true,
        compile_on_sync = true
    }
})

--  ╭─────────╮
--  │ Lualine │
--  ╰─────────╯
require("lualine").setup({
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
        lualine_c = {
            "CurrentFunction",
            {
                "diff",
                symbols = { added = "+", modified = "*", removed = "-" },
            },
        },
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
})
vim.opt.signcolumn = 'yes' -- Reserve space for diagnostic icons

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps { buffer = bufnr, preserve_mappings = false }
end)

require('mason').setup {}
require('mason-lspconfig').setup {
    ensure_installed = {
        'bashls', 'clangd', 'cmake', 'cssls', 'diagnosticls',
        'docker_compose_language_service', 'dockerls', 'gopls', 'grammarly',
        'html', 'jdtls', 'jsonls', 'lua_ls', 'marksman', 'perlnavigator',
        'pyre', 'tsserver', 'yamlls' },
    handlers = { lsp_zero.default_setup },
}

require('lspconfig').clangd.setup(
    { cmd = { "clangd", "--clang-tidy" } }
)
lsp_zero.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({
    paths = { "~/.dotfiles/nvim/snippets/",
        "~/.local/share/nvim/site/pack/packer/start/vim-snippets/" }
})

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
})

--  ╭───────────────────────╮
--  │ Snippet Configuration │
--  ╰───────────────────────╯

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
})

--  ╭──────────────────────────╮
--  │ Treesitter Language List │
--  ╰──────────────────────────╯

require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c", "cmake", "comment", "cpp", "dart", "dockerfile", "go", "gomod",
        "html", "http", "java", "javascript", "jsdoc", "json", "kotlin",
        "latex", "lua", "make", "perl", "python", "regex", "ruby",
        "rust", "toml", "tsx", "typescript", "vim", "vue", "yaml" },
})

--  ╭────────────────╮
--  │ Snippet Runner │
--  ╰────────────────╯
require("sniprun").setup({
    -- you can combo different display modes as desired
    display = {
        -- "Classic", -- display results in the command-line  area
        "VirtualTextOk", -- display ok results as virtual text
        -- "VirtualTextErr", -- display error results as virtual text
        -- "TempFloatingWindow", -- display results in a floating window
        -- "LongTempFloatingWindow", -- same as above, but only long results.
        "Terminal", -- display results in a vertical split
        -- "TerminalWithCode",-- display results and code history in a vertical
        -- split
        -- "NvimNotify",      -- display with the nvim-notify plugin
        -- "Api"              -- return output to a programming interface
    },
    display_options = {
        terminal_width = 45,      -- change the terminal display option width
        notification_timeout = 5, -- timeout for nvim_notify output
    },
    show_no_output = {
        "Classic",
        "TempFloatingWindow",
    },
})

--  ╭───────────────────────╮
--  │ Color scheme settings │
--  ╰───────────────────────╯

-- Reads current color value
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

-- Replaces the background color based on argument.
-- If true switches to dark mode
-- Else switches to light mode
function SetColors()
    if getColor() then
        vim.cmd [[ set background=dark ]]
    else
        vim.cmd [[ set background=light ]]
    end
end

--  ╭───────╮
--  │ Theme │
--  ╰───────╯
require('kanagawa').setup({
    compile = true,   -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = { bold = true, italic = true },
    keywordStyle = { italic = false, bold = true },
    statementStyle = { bold = false, italic = true },
    typeStyle = { bold = true },
    transparent = true,    -- do not set background color
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    theme = "wave",
    background = {         -- map the value of 'background' option to a theme
        dark = "wave",     -- try "dragon" !
        light = "lotus"
    },
})
vim.cmd([[colorscheme kanagawa]])



-- ┌──────────┐
-- │ NvimTree │
-- └──────────┘

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup()

--  ╭─────────────────────────────────────╮
--  │ vim instant markdown configurations │
--  ╰─────────────────────────────────────╯
vim.g.mkdp_browser = "epiphany"
vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_refresh_slow = 1

--  ╭─────────────────╮
--  │ GitSigns Config │
--  ╰─────────────────╯
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

--  ╭─────────╮
--  │ Trouble │
--  ╰─────────╯

require("trouble").setup {
    icons = false,
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    signs = { error = "⊗", warning = "", hint = "⚑", information = "🛈" },
}

-- ╭───────────╮
-- │ Telescope │
-- ╰───────────╯
require('telescope').setup {
    pickers = {
        find_files = { theme = "dropdown" },
        treesitter = { theme = "dropdown" },
        buffers = { theme = "dropdown" },
        help_tags = { theme = "dropdown" }
    },
}

-- ╭───────────────────╮
-- │   Window Movement │
-- ╰───────────────────╯
-- Change vim window focus
vim.cmd([[
" map <C-h> <C-w>h
" map <C-l> <C-w>l
" map <C-j> <C-w>j
" map <C-k> <C-w>k
map <silent> <A-h> :tabprevious<CR>
map <silent> <A-l> :tabnext<CR>
map <silent> <A-Left> :tabprevious<CR>
map <silent> <A-Right> :tabnext<CR>
map <silent> <A-1> :tabfirst <cr>
map <silent> <A-0> :tablast<cr>
]])

--quit without saving
vim.keymap.set("n", "qq", ":q!<CR>")
--quit after saving
vim.keymap.set("n", "qw", ":wq<CR>")
-- tab management
vim.keymap.set("n", "<A-n>", ":tabnew .<CR>")
vim.keymap.set("n", "<A-t>", ":vsplit <CR>")
vim.keymap.set("n", "<A-Enter>", ":NvimTreeFindFileToggle<CR>")

--  ╭──────────╮
--  │ autofill │
--  ╰──────────╯
-- Better multiple lines tabbing with < and >
require("autoclose").setup()
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- ╭───────────╮
-- │ Telescope │
-- ╰───────────╯
vim.keymap.set("n", "ff", ":Telescope find_files <CR>")
vim.keymap.set("n", "fd", ":Telescope treesitter <CR>")
vim.keymap.set("n", "fg", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "fh", "<cmd>Telescope help_tags<CR>")

-- ╭────────────────╮
-- │ Snippet runner │
-- ╰────────────────╯
vim.keymap.set("v", "rr", ":SnipRun <CR>")

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
vim.keymap.set("n", "<C-d>", ":lua vim.diagnostic.open_float() <CR>")
vim.keymap.set("n", "<A-d>", "<cmd>TroubleToggle document_diagnostics<cr>",
    { silent = true, noremap = true })
vim.keymap.set("n", "<A-D>", "<cmd>TroubleToggle workspace_diagnostics<cr>",
    { silent = true, noremap = true })
