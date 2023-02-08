-------------------------------------------------------------------------------
-- File: pkg/basics.lua
-- 
-- Author: Umut Sevdi
-- Created: 02/08/23
-- Description: Generic Lua configurations
-------------------------------------------------------------------------------

--  ╭───────────────────────────────────────────────╮
--  │ if NERDTree is the only window left remove it │
--  ╰───────────────────────────────────────────────╯
vim.cmd[[ autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif ]]


--  ╭─────────────────────────────────────╮
--  │ vim instant markdown configurations │
--  ╰─────────────────────────────────────╯
vim.filetype.plugin = on
--Uncomment to override defaults:
vim.g.instant_markdown_slow = 1
vim.g.instant_markdown_autostart = 1
--vim.g.instant_markdown_open_to_the_world = 1
--vim.g.instant_markdown_allow_unsafe_content = 1
vim.g.instant_markdown_allow_external_content = 1
--vim.g.instant_markdown_mathjax = 1
--vim.g.instant_markdown_mermaid = 1
--vim.g.instant_markdown_logfile = '/tmp/instant_markdown.log'
--vim.g.instant_markdown_autoscroll = 0
--vim.g.instant_markdown_port = 8888
--vim.g.instant_markdown_python = 1
vim.g.instant_markdown_browser = "epiphany"

--  ╭───────────────────────────╮
--  │ Dark/Light Mode Selecting │
--  ╰───────────────────────────╯
function SetColors(is_dark)
    if is_dark ~= true then
        vim.cmd [[ set background=dark ]]
    else
        vim.cmd [[ set background=light ]]
    end
end

--  local function is_dark_mode()
--      local f = io.open("/tmp/.cs", "r")
--      if f == nil then
--          vim.cmd [[ set background=dark ]]
--          return true
--      end
--      io.input(f)
--      local str = io.read()
--      io.close(f)
--      return str == "true"
--  end


--  ╭─────────────────╮
--  │ GitSigns Config │
--  ╰─────────────────╯
require('gitsigns').setup {
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
}

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
