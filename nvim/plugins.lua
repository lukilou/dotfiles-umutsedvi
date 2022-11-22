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

-- VimPlug Plugins
require('packer').startup({
    function(use)
        use 'wbthomason/packer.nvim'                                                           -- Packer can manage itself
        use 'lewis6991/impatient.nvim'                                                         -- Speedup Lua module load time
        use 'ryanoasis/vim-devicons'                                                           -- Vim NerdFont icons
        use 'nvim-lua/plenary.nvim'                                                            -- Telescope requires this package
        use 'lewis6991/gitsigns.nvim'
        use 'tpope/vim-fugitive'                                                               -- Git Integration
        use 'airblade/vim-gitgutter'                                                           -- Displays git diff
        use {'preservim/nerdtree', event = 'VimEnter'}
        use 'nvim-telescope/telescope.nvim'                                                    -- Telescope is a FZF extension that displays preview
        use 'nvim-lualine/lualine.nvim'                                                        -- Lualine is the bar on the bottom that displays elements
        use 'preservim/tagbar'                                                                 -- Tag bar displays functions, classes and variables of files on the left
        use 'junegunn/vim-easy-align'                                                          -- Auto align
        use 'LudoPinelli/comment-box.nvim'
        use {'kaicataldo/material.vim', branch = 'main' }
        use {'fatih/vim-go', run = ':GoUpdateBinaries', ft = {'go', 'mod'}}                    -- Go official vim plugin
        use {'junegunn/fzf', dir = '~/.fzf', run = './install --all'}
        use {'SirVer/ultisnips', requires= {'honza/vim-snippets'}}                             -- Snippet support
        use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}                            -- Syntax highlighting
        use {'neoclide/coc.nvim', branch = 'release', run = 'coc#util#install()'}           -- Conqueror of Completions: Language server for any language
        use {
          'weilbith/nvim-code-action-menu',
          after = 'coc.nvim',
          requires = 'xiyaowong/coc-code-action-menu.nvim',
          config = function()
            require 'coc-code-action-menu'
          end,
        }
        use {'instant-markdown/vim-instant-markdown', run = 'yarn install', ft = 'markdown'}    -- live markdown renderer server
        use {'turbio/bracey.vim', run = 'npm install --prefix server', ft= 'html'}              -- Run live web server to test Html
        use {'michaelb/sniprun', run= 'bash install.sh'}                                        -- Instant code runner
        use {'vim-test/vim-test'}                                                               -- Test plugin for Vim
    end,
    config = { max_jobs = 30, auto_reload_compiled = true, compile_on_sync = true }
})

-- import configurations
require("pkg/colorscheme")
vim.cmd('colorscheme material')

require("pkg/markdown")
require("pkg/nerdtree")
require("pkg/tagbar")
require("pkg/bracey")
require("pkg/test")
require("pkg/coc")

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

--  ╭────────────────╮
--  │ Coc Extensions │
--  ╰────────────────╯
vim.g.coc_global_extensions = {
   "coc-clangd",
   "coc-cmake",
   "coc-css",
   "coc-diagnostic",
   "coc-docker",
   "coc-emmet",
   "coc-eslint",
   "coc-explorer",
   "coc-html-css-support",
    "coc-java",
   "coc-json",
    "coc-lua",
   "coc-markdown-preview-enhanced",
   "coc-markdownlint",
   "coc-prettier",
   "coc-sh",
   "coc-snippets",
   "coc-stylelintplus",
   "coc-sql",
   "coc-tsserver",
   "coc-vimlsp",
   "coc-webview",
   "coc-xml",
   "coc-yaml",
}

--  ╭────────────────╮
--  │ Snippet Runner │
--  ╰────────────────╯
require("sniprun").setup({
   selected_interpreters = {}, -- use those instead of the default for the current filetype
   repl_enable = {}, -- enable REPL-like behavior for the given interpreters
   repl_disable = {}, -- disable REPL-like behavior for the given interpreters
   interpreter_options = { -- interpreter-specific options, see docs / :SnipInfo <name>
      -- use the interpreter name as key
      GFM_original = {
         use_on_filetypes = { "markdown.pandoc" }, -- the 'use_on_filetypes' configuration key is
         -- available for every interpreter
      },
      Python3_original = {
         error_truncate = "auto", -- Truncate runtime errors 'long', 'short' or 'auto'
         -- the hint is available for every interpreter
         -- but may not be always respected
      },
   },
   -- you can combo different display modes as desired
   display = {
      -- "Classic",                             -- display results in the command-line  area
      "VirtualTextOk", -- display ok results as virtual text (multiline is shortened)

      -- "VirtualTextErr",                      -- display error results as virtual text
      "TempFloatingWindow", -- display results in a floating window
      -- "LongTempFloatingWindow",              -- same as above, but only long results. To use with VirtualText__
      -- "Terminal",                            -- display results in a vertical split
      -- "TerminalWithCode",                    -- display results and code history in a vertical split
      -- "NvimNotify",                          -- display with the nvim-notify plugin
      -- "Api"                                  -- return output to a programming interface
   },
   display_options = {
      terminal_width = 45, -- change the terminal display option width
      notification_timeout = 5, -- timeout for nvim_notify output
   },
   -- You can use the same keys to customize whether a sniprun producing
   -- no output should display nothing or '(no output)'
   show_no_output = {
      "Classic",
      "TempFloatingWindow", -- implies LongTempFloatingWindow, which has no effect on its own
   },
   -- customize highlight groups (setting this overrides colorscheme)
   snipruncolors = {
      SniprunVirtualTextOk = { bg = "#66eeff", fg = "#000000", ctermbg = "Cyan", cterfg = "Black" },
      SniprunFloatingWinOk = { fg = "#66eeff", ctermfg = "Cyan" },
      SniprunVirtualTextErr = { bg = "#881515", fg = "#000000", ctermbg = "DarkRed", cterfg = "Black" },
      SniprunFloatingWinErr = { fg = "#881515", ctermfg = "DarkRed" },
   },
   -- miscellaneous compatibility/adjustement settings
   inline_messages = 0, -- inline_message (0/1) is a one-line way to display messages
   -- to workaround sniprun not being able to display anything

   borders = "single", -- display borders around floating windows
   -- possible values are 'none', 'single', 'double', or 'shadow'
   live_mode_toggle = "off", -- live mode toggle, see Usage - Running for more info
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
      globalstatus = false,
   },
   sections = {
      lualine_a = { "mode", "branch" },
      lualine_b = {
         {
            "filename",
            file_status = true, -- Displays file status (readonly status, modified status)
            path = 0, -- 0: Just the filename
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
               added = "DiffAdd", -- Changes the diff's added color
               modified = "DiffChange", -- Changes the diff's modified color
               removed = "DiffDelete", -- Changes the diff's removed color you
            },
            symbols = { added = "+", modified = "*", removed = "-" }, -- Changes the symbols used by the diff.
            source = nil, -- A function that works as a data source for diff.
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
            sources = { "nvim_diagnostic", "coc" },
            -- Displays diagnostics for the defined severity types
            sections = { "error", "warn", "info", "hint" },

            diagnostics_color = {
               -- Same values as the general color option can be used here.
               error = "DiagnosticError", -- Changes diagnostics' error color.
               warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
               info = "DiagnosticInfo", -- Changes diagnostics' info color.
               hint = "DiagnosticHint", -- Changes diagnostics' hint color.
            },
            symbols = { error = " ⊗ ", warn = "⚠ ", info = "🛈 ", hint = " " },
            colored = true, -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false, -- Show diagnostics even if there are none.
         },
      },
      lualine_y = { "location" },
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
   tabline = {},
   extensions = {},
})

--  ╭─────────────────╮
--  │ GitSigns Config │
--  ╰─────────────────╯
require('gitsigns').setup()
vim.cmd(':Gitsigns toggle_current_line_blame')
