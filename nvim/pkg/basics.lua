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
    local gsettings = assert(
        io.popen('/usr/bin/gsettings get org.gnome.desktop.interface color-scheme ', 'r'))
    local v = gsettings:read('*all'):gsub("\n", ""):gsub("'", "")
    gsettings:close()
    return v == "prefer-dark"
end

-- Replaces the background color based on argument.
-- If true switches to dark mode
-- Else switches to light mode
function SetColors()
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
SetColors()

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
require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "~/.dotfiles/nvim/pkg/snippets/" } })
require("luasnip.loaders.from_snipmate").lazy_load({
    paths = { "~/.local/share/nvim/site/pack/packer/start/vim-snippets/" } })


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
