-------------------------------------------------------------------------------
-- File: init.lua
--
-- Author: Umut Sevdi
-- Created: 04/07/22
-- Description: init.lua is the primary configuration file that initializes
-- basic settings and initializes basic Lua configurations.
-- It also links the configuration files of plugins respectively.
--- {@plugins.lua}  manages all plugins and their configuration.
--- {@keybinding.lua} manages keybindings.
-------------------------------------------------------------------------------
vim.cmd([[
set shell=$SHELL
set encoding=UTF-8
" Colors
syntax on
" Enable syntax highlighting
set t_8f=^[[38;2;%lu;%lu;%lum        " set foreground color
set t_8b=^[[48;2;%lu;%lu;%lum        " set background color
set t_Co=256                         " Enable 256 colors
" Recommended by CoC
set cmdheight=1 " height of command-line at the bottom
set shortmess+=c
set showtabline=0
" set manual folding for functions, conditions etc.
set foldmethod=manual
" set mouse=extend
set mousemodel=extend
set inccommand=nosplit
set conceallevel=0
set shiftwidth=4
set expandtab
set smarttab
set smartindent
set spell
]])
vim.o.termguicolors = true
vim.o.hidden = true
vim.o.updatetime = 200
vim.o.timeoutlen = 500
-- Disable backup files
vim.o.backup = false
vim.o.writebackup = false
-- set cmdheight=1 height of commandline at the bottom
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
-- set inccommand=nosplit
vim.o.splitright = true
vim.o.splitbelow = true
-- set conceallevel=0
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
-------------------------------------------------------------------------------
-- File: plugins.lua
--
-- Author: Umut Sevdi
-- Created: 04/07/22
-- Description: Plugins.lua is the configuration file that imports necessary
-- plugins. It also links the configuration files of plugins respectively.
-------------------------------------------------------------------------------
--  ╭────────────────╮
--  │ Packer Plugins │
--  ╰────────────────╯

vim.cmd [[packadd packer.nvim]]
require('packer').startup({
    function(use)
        use 'wbthomason/packer.nvim'  -- packer can manage itself
        use 'lewis6991/gitsigns.nvim' -- git symbols on the left
        use 'tpope/vim-fugitive'      -- git Integration
        use {
            'nvim-telescope/telescope.nvim',
            requires = { 'nvim-lua/plenary.nvim' },
        }                                  -- fzf extension that displays preview
        use 'preservim/nerdtree'           -- nerdtree
        use 'nvim-lualine/lualine.nvim'    -- bottom bar
        use 'preservim/tagbar'             -- a bar displays functions, classes and variables of files on the left
        use 'junegunn/vim-easy-align'      -- auto align
        use 'LudoPinelli/comment-box.nvim' -- comment box
        use "rebelot/kanagawa.nvim"
        use "folke/trouble.nvim"
        use { 'junegunn/fzf',
            dir = '~/.fzf',
            run = './install --all'
        } -- fzf
        use { 'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate'
        } -- syntax highlighting
        use { 'instant-markdown/vim-instant-markdown',
            run = 'yarn install',
            ft = 'markdown'
        }                                                    -- live markdown renderer server
        use { 'michaelb/sniprun', run = 'bash install.sh', } -- instant code runner
        use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v3.x',
            requires = {
                --- Uncomment the two plugins below if you want to manage the language servers from neovim
                { 'williamboman/mason.nvim' },
                { 'williamboman/mason-lspconfig.nvim' },

                -- LSP Support
                { 'neovim/nvim-lspconfig' },
                -- Autocompletion
                { 'hrsh7th/nvim-cmp' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'L3MON4D3/LuaSnip' },
                --              -- Snippets
                { 'L3MON4D3/LuaSnip' },
                { 'honza/vim-snippets' },
                { 'rafamadriz/friendly-snippets' },
            }
        }
        use {
            'akinsho/flutter-tools.nvim',
            requires = {
                'nvim-lua/plenary.nvim',
                'stevearc/dressing.nvim', -- optional for vim.ui.select
            },
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
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode", "branch" },
        lualine_b = {
            {
                "filename",
                file_status = true, -- Displays file status (readonly status, modified status)
                path = 0,           -- 0: Just the filename
                -- 1: Relative path
                -- 2: Absolute path
                -- 3: Absolute path, with tilde as the home directory

                shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                -- for other components. (terrible name, any suggestions?)
                symbols = {
                    modified = " * ", -- Text to show when the file is modified.
                    readonly = "  ", -- Text to show when the file is non-modifiable or readonly.
                    unnamed = "[No Name]", -- Text to show for unnamed buffers.
                },
            },
        },
        lualine_c = {
            "CurrentFunction",
            {
                "diff",
                colored = true, -- Displays a colored diff status if set to true
                diff_color = {
                    -- Same color values as the general color option can be used here.
                    added = "DiffAdd",                                    -- Changes the diff's added color
                    modified = "DiffChange",                              -- Changes the diff's modified color
                    removed = "DiffDelete",                               -- Changes the diff's removed color you
                },
                symbols = { added = "+", modified = "*", removed = "-" }, -- Changes the symbols used by the diff.
                source = nil,                                             -- A function that works as a data source for diff.
                -- It must return a table as such:
                --   { added = add_count, modified = modified_count, removed = removed_count }
                -- or nil on failure. count <= 0 won't be displayed.
            },
        },
        lualine_x = {
            {
                "diagnostics",
                -- Table of diagnostic sources, available sources are:
                --   'nvim_lsp', 'nvim_diagnostic', 'coc', 'ale', 'vim_lsp'.
                -- or a function that returns a table as such:
                --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
                sources = { "nvim_diagnostic", "nvim_lsp" },
                -- Displays diagnostics for the defined severity types
                sections = { "error", "warn", "info", "hint" },

                diagnostics_color = {
                    -- Same values as the general color option can be used here.
                    error = "DiagnosticError", -- Changes diagnostics' error color.
                    warn = "DiagnosticWarn",   -- Changes diagnostics' warn color.
                    info = "DiagnosticInfo",   -- Changes diagnostics' info color.
                    hint = "DiagnosticHint",   -- Changes diagnostics' hint color.
                },
                symbols = { error = " ⊗ ", warn = " ", info = "🛈 ", hint = "⚑ " },
                colored = true,           -- Displays diagnostics status in color if set to true.
                update_in_insert = false, -- Update diagnostics in insert mode.
                always_visible = false,   -- Show diagnostics even if there are none.
            },
        },
        lualine_y = { "tabs", "location" },
        lualine_z = { "encoding", "filetype" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    winbar = {},
    tabline = {},
    extensions = {},
})
vim.opt.signcolumn = 'yes'        -- Reserve space for diagnostic icons

require("flutter-tools").setup {} -- use defaults

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        buffer = bufnr,
        preserve_mappings = false
    })
end)


require('mason').setup({})
require('mason-lspconfig').setup {
    ensure_installed = {
        'bashls',
        'clangd',
        'cmake',
        'cssls',
        'diagnosticls',
        'docker_compose_language_service',
        'dockerls',
        'gopls',
        'grammarly',
        'html',
        'jdtls',
        'jsonls',
        'lua_ls',
        'marksman',
        'perlnavigator',
        'pyre',
        'templ',
        'tsserver', -- JavaScript / Typescript
        'yamlls',
    },
    handlers = { lsp_zero.default_setup },
}

lsp_zero.set_preferences({
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
lsp_zero.configure('clangd', { cmd = { "clangd", "--fallback-style=Webkit" } })
lsp_zero.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
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
        "dart",
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
})


--  ╭────────────────╮
--  │ Snippet Runner │
--  ╰────────────────╯
require("sniprun").setup({
    -- you can combo different display modes as desired
    display = {
        -- "Classic",                             -- display results in the command-line  area
        "VirtualTextOk", -- display ok results as virtual text (multiline is shortened)

        -- "VirtualTextErr",                      -- display error results as virtual text
        -- "TempFloatingWindow", -- display results in a floating window
        -- "LongTempFloatingWindow",              -- same as above, but only long results. To use with VirtualText__
        "Terminal", -- display results in a vertical split
        -- "TerminalWithCode",                    -- display results and code history in a vertical split
        -- "NvimNotify",                          -- display with the nvim-notify plugin
        -- "Api"                                  -- return output to a programming interface
    },
    display_options = {
        terminal_width = 45,      -- change the terminal display option width
        notification_timeout = 5, -- timeout for nvim_notify output
    },
    -- You can use the same keys to customize whether a sniprun producing
    -- no output should display nothing or '(no output)'
    show_no_output = {
        "Classic",
        "TempFloatingWindow", -- implies LongTempFloatingWindow, which has no effect on its own
    },
})


-------------------------------------------------------------------------------
-- File: pkg/basics.lua
--
-- Author: Umut Sevdi
-- Created: 02/08/23
-- Description: Generic Lua configurations
-------------------------------------------------------------------------------

--  ╭───────────────────────╮
--  │ Color scheme settings │
--  ╰───────────────────────╯
-- Reads current color value
local function get_color()
    local gsettings = assert(io
        .popen('/usr/bin/gsettings get org.gnome.desktop.interface color-scheme ', 'r'))
    local v = gsettings:read('*all'):gsub("\n", ""):gsub("'", "")
    gsettings:close()
    return v == "prefer-dark"
end

-- Replaces the background color based on argument.
-- If true switches to dark mode
-- Else switches to light mode
function set_colors()
    if get_color() then
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
    string = { italic = true },
    typeStyle = { bold = true },
    transparent = true,    -- do not set background color
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = {             -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    theme = "wave",    -- Load "wave" theme when 'background' option is not set
    background = {     -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus"
    },
})


vim.cmd([[colorscheme kanagawa-lotus]])
--  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
set_colors()

--  ╭───────────────────────────────────────────────╮
--  │ if NERDTree is the only window left remove it │
--  ╰───────────────────────────────────────────────╯
vim.cmd [[ autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif ]]
-- vim.g.NERDTreeBookmarksFile = "$HOME/.dotfiles/nvim/.NERDTreeBookmarks"
vim.g.NERDTreeShowBookmarks = 1
vim.g.NERDTreeShowLineNumbers = 1
vim.g.NERDTreeDirArrowExpandable = ""
vim.g.NERDTreeDirArrowCollapsible = ""
--  ╭─────────────────────────────────────╮
--  │ vim instant markdown configurations │
--  ╰─────────────────────────────────────╯
vim.filetype.plugin = true
--Uncomment to override defaults:
vim.g.instant_markdown_slow = 1
vim.g.instant_markdown_autostart = 0
--vim.g.instant_markdown_open_to_the_world = 1
--vim.g.instant_markdown_allow_unsafe_content = 1
vim.g.instant_markdown_allow_external_content = 1
--vim.g.instant_markdown_mathjax = 1
--vim.g.instant_markdown_mermaid = 1
--vim.g.instant_markdown_logfile = '/tmp/instant_markdown.log'
vim.g.instant_markdown_autoscroll = 1
--vim.g.instant_markdown_port = 8888
--vim.g.instant_markdown_python = 1
vim.g.instant_markdown_browser = "epiphany"

--  ╭─────────────────╮
--  │ GitSigns Config │
--  ╰─────────────────╯
require('gitsigns').setup {
    signs              = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    current_line_blame = true,  -- Toggle with `:Gitsigns toggle_current_line_blame`
    signcolumn         = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl              = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl             = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff          = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir       = {
        interval = 1000,
        follow_files = true
    },
}
--  ╭───────────────────────╮
--  │ Snippet Configuration │
--  ╰───────────────────────╯
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({
    paths = {
        "~/.dotfiles/nvim/snippets/",
        "~/.local/share/nvim/site/pack/packer/start/vim-snippets/" }
})


--  ╭─────────╮
--  │ Trouble │
--  ╰─────────╯

require("trouble").setup {
    icons = false,
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    signs = {
        -- icons / text used for a diagnostic
        error = "⊗",
        warning = "",
        hint = "⚑",
        information = "🛈",
        other = "﫠"
    },
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
vim.g.tagbar_position = "right"
vim.g.tagbar_autoclose = 0
vim.g.tagbar_autofocus = 0
vim.g.tagbar_foldlevel = 2
vim.g.tagbar_autoshowtag = 1
-- Display
vim.g.tagbar_iconchars = {
    "",
    "",
}
vim.g.tagbar_wrap = 1
vim.g.tagbar_show_data_type = 1
vim.g.tagbar_show_visibility = 1
vim.g.tagbar_visibility_symbols = {
    public = "󰡭 ",
    protected = "󱗤 ",
    private = "󰛑 ",
}
vim.g.tagbar_show_linenumbers = 1
vim.g.tagbar_show_linenumbers = 1
vim.g.tagbar_case_insensitive = 1
vim.g.tagbar_show_tag_count = 1
vim.g.tagbar_compact = 1
vim.g.tagbar_indent = 1
-- Preview Window
vim.g.tagbar_autopreview = 0
vim.g.tagbar_previewwin_pos = "belowleft"
vim.g.tagbar_scopestrs = {
    class = "\\uf0e8",
    struct = "\\uf0e8",
    const = "\\uf8ff",
    constant = "\\uf8ff",
    enum = "\\uf702",
    field = "\\uf30b",
    func = "\\uf794",
    ["function"] = "\\uf794",
    getter = "\\ufab6",
    implementation = "\\uf776",
    interface = "\\uf7fe",
    map = "\\ufb44",
    member = "\\uf02b",
    method = "\\uf6a6",
    setter = "\\uf7a9",
    variable = "\\uf71b",
}
--  ╭───────────────────────╮
--  │ Import configurations │
--  ╰───────────────────────╯
-------------------------------------------------------------------------------
-- File: keybindings.lua
--
-- Author: Umut Sevdi
-- Created: 04/07/22
-- Description: keybindings.lua contains custom keybindings for various things.
-------------------------------------------------------------------------------

-- ╭───────────────────╮
-- │   Window Movement │
-- ╰───────────────────╯
-- Change vim window focus
vim.cmd([[
" map <C-h> <C-w>h
" map <C-l> <C-w>l
" map <C-j> <C-w>j
" map <C-k> <C-w>k
" Tabs
" Move around tabs
map <silent> <A-h> :tabprevious<CR>
map <silent> <A-l> :tabnext<CR>
map <silent> <A-Left> :tabprevious<CR>
map <silent> <A-Right> :tabnext<CR>
map <silent> <A-1> :tabfirst <cr>
map <silent> <A-0> :tablast<cr>
" Jump definition
]])

--quit without saving
vim.keymap.set("n", "qq", ":q!<CR>")
--quit after saving
vim.keymap.set("n", "qw", ":wq<CR>")
-- tab management
vim.keymap.set("n", "<A-n>", ":tabnew .<CR>")
vim.keymap.set("n", "<A-t>", ":vsplit .<CR>")
vim.keymap.set("n", "<A-Enter>", ":NERDTreeToggle | TagbarToggle<CR>")

--  ╭──────────╮
--  │ autofill │
--  ╰──────────╯
vim.keymap.set("i", '"', '""<left>')
vim.keymap.set("i", "'", "''<left>")
vim.keymap.set("i", "(", "()<left>")
vim.keymap.set("i", "[", "[]<left>")
vim.keymap.set("i", "{", "{}<left>")
vim.keymap.set("i", "(<CR>", "(<CR>)<ESC>O")
vim.keymap.set("i", "(;<CR>", "(<CR>);<ESC>O")
vim.keymap.set("i", "[<CR>", "[<CR>]<ESC>O")
vim.keymap.set("i", "[;<CR>", "[<CR>];<ESC>O")
vim.keymap.set("i", "{<CR>", "{<CR>}<ESC>O")
vim.keymap.set("i", "{;<CR>", "{<CR>};<ESC>O")
vim.keymap.set("i", '"<CR>', '"<CR>"<ESC>O')
vim.keymap.set("i", '";<CR>', '"<CR>";<ESC>O')
vim.keymap.set("i", "'<CR>", "'<CR>'<ESC>O")
vim.keymap.set("i", "';<CR>", "'<CR>';<ESC>O")
-- Better multiple lines tabbing with < and >
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
--Coc Diagnostic Menu
vim.keymap.set("n", "<C-d>", ":lua vim.diagnostic.open_float() <CR>")
vim.keymap.set("n", "<A-d>", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<A-D>", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
