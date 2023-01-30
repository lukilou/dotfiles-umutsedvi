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
        use {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.0',
            requires = { 'nvim-lua/plenary.nvim' }
        } -- fzf extension that displays preview
        use 'preservim/nerdtree'
        use 'nvim-lualine/lualine.nvim' -- a bar on the bottom that displays elements
        use 'preservim/tagbar' -- a bar displays functions, classes and variables of files on the left
        use 'junegunn/vim-easy-align' -- auto align
        use 'LudoPinelli/comment-box.nvim'
        use 'morhetz/gruvbox'
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
        use 'jakewvincent/mkdnflow.nvim' -- markdown extension
        use { 'turbio/bracey.vim',
            run = 'npm install --prefix server',
            ft = 'html'
        } -- run live server to test html
        use { 'michaelb/sniprun',
            run = 'bash install.sh'
        } -- instant code runner
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
                { 'rafamadriz/friendly-snippets' },
                { 'L3MON4D3/LuaSnip' },
                { 'honza/vim-snippets' },
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
--  │ Import configurations │
--  ╰───────────────────────╯

require('pkg/tree-sitter-config')
require('pkg/lualine-config')
require("pkg/tagbar")
require('pkg/lsp-config')
require('pkg/snip-runner-config')
require("pkg/bracey-config")
require("pkg/markdown")
require("pkg/nerdtree-config")
require("pkg/auto-dark-mode")

--  ╭───────────────────────╮
--  │ Color scheme settings │
--  ╰───────────────────────╯
vim.g.gruvbox_italic = 1
vim.g.gruvbox_termcolors = 16
vim.cmd 'colorscheme gruvbox'
--  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
SetColors()


--  ╭─────────────────╮
--  │ GitSigns Config │
--  ╰─────────────────╯
require('gitsigns').setup()
vim.cmd(':Gitsigns toggle_current_line_blame')


--  ╭───────────────────────╮
--  │ Snippet Configuration │
--  ╰───────────────────────╯
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "~/.dotfiles/nvim/pkg/snippets/" } })
require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "~/.local/share/nvim/site/pack/packer/start/vim-snippets/" } })

--  ╭───────────────╮
--  │ Markdown Flow │
--  ╰───────────────╯
require('mkdnflow').setup({
    links = {
        transform_explicit = function(text)
            -- Make lowercase, remove spaces, and reverse the string
            return string.lower(text:gsub(' ', ''))
        end
    }
})
