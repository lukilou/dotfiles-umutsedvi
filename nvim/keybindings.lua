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
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k
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
vim.keymap.set("n", "<A-f>", ":lua vim.lsp.buf.format() <CR>")
-- Code actions
vim.keymap.set("n", "<A-q>", ":lua vim.lsp.buf.code_action() <CR>")
-- Bulk rename
vim.keymap.set("n", "<A-r>", ":lua vim.lsp.buf.rename() <CR>")
--Coc Diagnostic Menu
vim.keymap.set("n", "<C-d>", ":lua vim.diagnostic.open_float() <CR>")
vim.keymap.set("n", "<A-d>", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<A-D>", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
