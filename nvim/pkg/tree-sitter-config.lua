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
