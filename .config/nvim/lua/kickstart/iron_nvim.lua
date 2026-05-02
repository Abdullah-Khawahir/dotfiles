return {
  'hkupty/iron.nvim',
  config = function()
    local iron = require 'iron.core'
    iron.setup {
      config = {
        repl_definition = {
          python = {
            command = { 'ipython' },
          },
        },
        repl_open_cmd = 'vsplit ',
      },
      keymaps = {
        -- send_motion = "<leader>sc",
        visual_send = '<leader>n',
        send_file = '<leader>N',
        send_line = '<leader>n',
        -- optional: clear REPL
        clear = '<leader>nc',
      },
    }
  end,
}
