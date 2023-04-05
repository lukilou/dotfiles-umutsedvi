--  ╭────────────────╮
--  │ Snippet Runner │
--  ╰────────────────╯
require("sniprun").setup({
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
      -- "TempFloatingWindow", -- display results in a floating window
      -- "LongTempFloatingWindow",              -- same as above, but only long results. To use with VirtualText__
       "Terminal",                            -- display results in a vertical split
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
})


