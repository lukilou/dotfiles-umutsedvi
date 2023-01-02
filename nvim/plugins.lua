--
-- ╭─────────────╮
-- │ Plugins.lua │
-- ╰─────────────╯
-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │ Plugins.lua is the configuration file that imports necessary plugins.        │
-- │ It also links the configuration files of plugins respectively.               │
-- │  - {@link plug} contains the list of imported VimPlug plugins.               │
-- │  - {@link nvim-treesitter.configs} contains treesitter language support list.│
-- │  - {@link coc_global_extensions} includes Conqueror of Completions(CoC)      │
-- │  related configurations.                                                     │
-- │  - {@link sniprun} contains snippet runner configurations                    │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
-- @author umutsevdi

--  ╭────────────────╮
--  │ Packer Plugins │
--  ╰────────────────╯

vim.cmd [[packadd packer.nvim]]

require('packer').startup({
    function(use)
        use 'wbthomason/packer.nvim' -- packer can manage itself
        use 'lewis6991/impatient.nvim' -- speedup Lua module load time
        use 'ryanoasis/vim-devicons' -- vim NerdFont icons
        use 'lewis6991/gitsigns.nvim' -- git add, update, delete symbols
        use 'tpope/vim-fugitive' -- git Integration
        use 'airblade/vim-gitgutter' -- displays git diff
        use 'preservim/nerdtree'
        use {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.0',
            requires = { 'nvim-lua/plenary.nvim' }
        } -- fzf extension that displays preview
        use 'nvim-lualine/lualine.nvim' -- a bar on the bottom that displays elements
        use 'preservim/tagbar' -- a bar displays functions, classes and variables of files on the left
        use 'junegunn/vim-easy-align' -- auto align
        use 'LudoPinelli/comment-box.nvim'
        use 'marko-cerovac/material.nvim'
        use { 'fatih/vim-go',
            run = ':GoUpdateBinaries',
            ft = { 'go', 'mod' }
        } -- go official vim plugin
        use { 'junegunn/fzf',
            dir = '~/.fzf',
            run = './install --all'
        }
        use { 'SirVer/ultisnips',
            requires = { 'honza/vim-snippets' }
        } -- snippet support
        use { 'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate'
        } -- syntax highlighting
        use { 'instant-markdown/vim-instant-markdown',
            run = 'yarn install',
            ft = 'markdown'
        } -- live markdown renderer server
        use { 'turbio/bracey.vim',
            run = 'npm install --prefix server',
            ft = 'html'
        } -- run live server to test html
        use { 'michaelb/sniprun',
            run = 'bash install.sh'
        } -- instant code runner
        use 'vim-test/vim-test' -- test plugin for Vim
        use 'mbbill/undotree'
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

--  ╭───────────────────────╮
--  │ Color scheme settings │
--  ╰───────────────────────╯

vim.cmd.colorscheme('material')
vim.g.material_style = "default"

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

--  ╭───────────────────────╮
--  │ Import configurations │
--  ╰───────────────────────╯

require('pkg/tsitter')
require('pkg/lline')
require("pkg/nerdtree")
require("pkg/tagbar")
require('pkg/lsp-config')
require('pkg/sr')
require("pkg/bracey")
require("pkg/markdown")
require("pkg/test")

--  ╭─────────────────╮
--  │ GitSigns Config │
--  ╰─────────────────╯
require('gitsigns').setup()
vim.cmd(':Gitsigns toggle_current_line_blame')
