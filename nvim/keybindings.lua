-------------------------------------------------------------------------------
-- File: keybindings.lua
--
-- Author: Umut Sevdi
-- Created: 04/07/22
-- Description: keybindings.lua contains custom keybindings for various things.
-------------------------------------------------------------------------------

vim.cmd([[
"  ╭───────────────────╮
"  │ " Window Movement │
"  ╰───────────────────╯
" Change vim window focus
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-Left> <C-w>h
map <C-Down> <C-w>j
map <C-Up> <C-w>k
map <C-Right> <C-w>l

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
--source $MYVIMRC
vim.keymap.set("n", "<leader>ss", ":source $MYVIMRC<CR>")
-- tab management
vim.keymap.set("n", "<A-n>", ":tabnew .<CR>")
vim.keymap.set("n", "<A-t>", ":vsplit .<CR>")
vim.keymap.set("n", "<A-Enter>", ":NERDTreeToggle | TagbarToggle<CR>")
-- vim.keymap.set("n", "<A-Enter>", ":Centerpad<CR>")



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
-- For C,  pressing K on the keyword will pull up the built-in
-- manpage directly. For instance, place the cursor on the printf keyword:
--Snippet runner
vim.keymap.set("v", "rr", ":SnipRun <CR>")
-- Better multiple lines tabbing with < and >
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
