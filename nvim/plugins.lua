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
        use 'wbthomason/packer.nvim' -- packer can manage itself
        use 'lewis6991/impatient.nvim' -- speedup Lua module load time
        use 'ryanoasis/vim-devicons' -- icons
        use 'lewis6991/gitsigns.nvim' -- git symbols on the left
        use 'tpope/vim-fugitive' -- git Integration
        use {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.0',
            requires = { 'nvim-lua/plenary.nvim' }
        } -- fzf extension that displays preview
        use 'preservim/nerdtree' -- nerdtree
        use 'nvim-lualine/lualine.nvim' -- bottom bar
        use 'preservim/tagbar' -- a bar displays functions, classes and variables of files on the left
        use 'junegunn/vim-easy-align' -- auto align
        use 'LudoPinelli/comment-box.nvim' -- comment box
        use 'morhetz/gruvbox' -- theme
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
        } -- live markdown renderer server
        use 'jakewvincent/mkdnflow.nvim' -- markdown extension
        use { 'michaelb/sniprun',
            run = 'bash install.sh',
        } -- instant code runner
        use 'smithbm2316/centerpad.nvim' -- move window the center

        use {
            'VonHeikemen/lsp-zero.nvim',
            requires = {
                -- LSP Support
                { 'neovim/nvim-lspconfig' },
                { 'williamboman/mason.nvim' },
                { 'williamboman/mason-lspconfig.nvim' },

                -- Autocompletion
                { 'hrsh7th/nvim-cmp' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'saadparwaiz1/cmp_luasnip' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-nvim-lua' },

                -- Snippets
                { 'L3MON4D3/LuaSnip' },
                { 'honza/vim-snippets' },
                { 'rafamadriz/friendly-snippets' },
            }
        }
        use {
            "folke/trouble.nvim",
            requires = "nvim-tree/nvim-web-devicons",
            config = function()
                require("trouble").setup {
                    -- your configuration comes here
                    -- or leave it empty to use the default settings
                    -- refer to the configuration section below
                }
            end -- diagnostics window
        }
    end,
    config = {
        max_jobs = 30,
        auto_reload_compiled = true,
        compile_on_sync = true
    }
})

--  ╭───────────────────────╮
--  │ Import configurations │
--  ╰───────────────────────╯

require("pkg/basics")
require('pkg/tree-sitter-config')
require('pkg/lualine-config')
require("pkg/tagbar")
require('pkg/lsp-config')
require('pkg/snip-runner-config')
