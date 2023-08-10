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


require("plugins")
require("keybindings")
