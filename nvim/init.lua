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
--vim.o.timeoutlen = 500
-- Disable backup files
vim.o.backup = false
vim.o.writebackup = false
vim.o.signcolumn = 'yes'
-- show line numbers
vim.o.number = true
vim.o.cursorline = true
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
vim.o.wrap = false
vim.o.textwidth = 300
vim.o.list = true
vim.o.jumpoptions = "view"


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
            "nvim-neo-tree/neo-tree.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                "MunifTanjim/nui.nvim",
            },
            config = function()
                require("neo-tree").setup({
                    filesystem = {
                        filtered_items = {
                            hide_dotfiles = false
                        }
                    }
                })
            end
        }
        use "ellisonleao/glow.nvim"
        use 'nvim-lualine/lualine.nvim'    -- bottom bar
        use 'LudoPinelli/comment-box.nvim' -- comment box
        use 'm4xshen/autoclose.nvim'
        use { "folke/trouble.nvim"}
        use { 'junegunn/fzf',
            dir = '~/.fzf',
            run = './install --all'
        } -- fzf
        use { 'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate'
        }
        use "rebelot/kanagawa.nvim"
        use {
 'VonHeikemen/lsp-zero.nvim', branch = 'v4.x',
            requires = {
                {'neovim/nvim-lspconfig'},
                {'hrsh7th/nvim-cmp'},
                {'hrsh7th/cmp-nvim-lsp'},
                {'L3MON4D3/LuaSnip'},

                { 'williamboman/mason.nvim' },
                { 'williamboman/mason-lspconfig.nvim' },

                { 'L3MON4D3/LuaSnip' },
                { 'rafamadriz/friendly-snippets' },
            }
        }
        -- debugger
        use { "rcarriga/nvim-dap-ui",
            requires = {
                "mfussenegger/nvim-dap",
                "nvim-neotest/nvim-nio",
                "folke/neodev.nvim"
            }
        }
    end,
    config = {
        max_jobs = 30,
        auto_reload_compiled = true,
        compile_on_sync = true
    }
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
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = {             -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    theme = "wave",    -- Load "wave" theme when 'background' option is not set
    background = {     -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus"
    },
})

vim.cmd("colorscheme kanagawa")


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

require("glow").setup {}

local cmp = require('cmp')
cmp.setup({
  sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load({
          paths = { "~/.dotfiles/nvim/snippets/",
              "~/.local/share/nvim/site/pack/packer/start/vim-snippets/" }
      })
    end,
  },
  mapping = cmp.mapping.preset.insert({
--      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
--      ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
})


local lsp_zero = require('lsp-zero')
require('mason').setup {}

local lsp_attach = function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end

lsp_zero.extend_lspconfig({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  lsp_attach = lsp_attach,
  float_border = 'rounded',
  sign_text = true,
})


require('mason-lspconfig').setup {
    ensure_installed = { 'cmake', 'gopls', 'marksman', 'pyre' },
    handlers = { lsp_zero.default_setup },
}

require('lspconfig').clangd.setup {
    { cmd = { "clangd", "--clang-tidy" } }
}

require('lspconfig').bashls.setup {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh" },
}

require('lspconfig').diagnosticls.setup {
    cmd = { "diagnostic-languageserver", "--stdio" },
    filetypes = {},
}

require('lspconfig').grammarly.setup {
    cmd = { "grammarly-languageserver", "--stdio" },
    filetypes = { "markdown" },
}

require 'lspconfig'.lua_ls.setup {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or
            vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force',
        client.config.settings.Lua, {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME }
            }
        })
    end,
    settings = {
        Lua = {}
    }
}

-- VS Code language server
require('lspconfig').html.setup {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "templ" },
    init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
            css = true,
            javascript = true
        },
        provideFormatter = true
    }
}

require('lspconfig').cssls.setup {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "html", "css", "scss", "less" },
}

require('lspconfig').ts_ls.setup {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx",
        "typescript", "typescriptreact", "typescript.tsx" },
}

require('lspconfig').jsonls.setup {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    init_options = {
        provideFormatter = true
    }
}

lsp_zero.extend_lspconfig({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  lsp_attach = lsp_attach,
  float_border = 'rounded',
  sign_text = true,
})




-- ╭───────────╮
-- │ Debuggers │
-- ╰───────────╯
local dap = require("dap")
require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})
require("dapui").setup()
dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}
dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
        -- add this if on windows, otherwise server won't open successfully
        -- detached = false
    }
}
dap.configurations.cpp = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    },
    {
        name = "Select and attach to process",
        type = "gdb",
        request = "attach",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        pid = function()
            local name = vim.fn.input('Executable name (filter): ')
            return require("dap.utils").pick_process({ filter = name })
        end,
        cwd = '${workspaceFolder}'
    },
    {
        name = 'Attach to gdbserver :1234',
        type = 'gdb',
        request = 'attach',
        target = 'localhost:1234',
        program = function()
            require("dapui").open()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}'
    },
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
    },
    {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}


--  ╭───────────────────────╮
--  │ Snippet Configuration │
--  ╰───────────────────────╯

vim.diagnostic.config({
    virtual_text = { prefix = ' ', spacing = 0 },
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
        "gdscript", "html", "http", "java", "javascript", "jsdoc", "json",
        "lua", "make", "perl", "python", "regex", "rust", "toml",
        "tsx", "typescript", "yaml", "vim", "vimdoc" },
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

SetColors()

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
    icons =  {
        indent = {
            fold_open = "", -- icon used for open folds
            fold_closed = "", -- icon used for closed folds
        },
        folder_open = "", -- icon used for open folds
        folder_closed = "", -- icon used for closed folds
        signs = { error = "⊗", warning = "", hint = "⚑", information = "🛈" },
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

-- ╭───────────────────╮
-- │   Window Movement │
-- ╰───────────────────╯
-- Change vim window focus
vim.cmd([[
    map <silent> <A-h> :tabprevious<CR>
    map <silent> <A-l> :tabnext<CR>
    map <silent> <A-Left> :tabprevious<CR>
    map <silent> <A-Right> :tabnext<CR>
    map <silent> <A-1> :tabfirst <cr>
    map <silent> <A-0> :tablast<cr>
]])

vim.keymap.set("n", "qq", ":q! <CR>")
-- tab management
vim.keymap.set("n", "<A-n>", ":tabnew | Neotree current <CR>")
vim.keymap.set("n", "<A-t>", ":vsplit | Neotree current <CR>")
vim.keymap.set("n", "<A-Enter>", ":Neotree toggle right <CR>")

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
vim.keymap.set("n", "fs", ":Telescope live_grep <CR>")
vim.keymap.set("n", "fd", ":Telescope lsp_references <CR>")
vim.keymap.set("n", "fg", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "fh", "<cmd>Telescope man_pages<CR>")
--  ╭─────────────────────────────────────────────╮
--  │   Language Server Protocol Configurations   │
--  ╰─────────────────────────────────────────────╯
vim.keymap.set("n", "<C-d>", ":lua require(\"dapui\").toggle() <CR>")
vim.keymap.set("n", "<C-b>", "<cmd>DapToggleBreakpoint <CR>")
vim.keymap.set("n", "<A-f>", ":lua vim.lsp.buf.format() <CR>")
-- Code actions
vim.keymap.set("n", "<A-q>", ":lua vim.lsp.buf.code_action() <CR>")
-- Bulk rename
vim.keymap.set("n", "<A-r>", ":lua vim.lsp.buf.rename() <CR>")
vim.keymap.set("n", "<A-d>", "<cmd>TroubleToggle document_diagnostics<cr>",
    { silent = true, noremap = true })
vim.keymap.set("n", "<A-D>", "<cmd>TroubleToggle workspace_diagnostics<cr>",
    { silent = true, noremap = true })


-- if WINDOWS modify clipboard
vim.cmd([[
if executable('clip.exe')
    let g:clipboard = {
        \   'name': 'WslClipboard',
        \   'copy': {
        \      '+': 'clip.exe',
        \      '*': 'clip.exe',
        \    },
        \   'paste': {
        \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \   },
        \   'cache_enabled': 0,
    \ }
endif
]])
