return {
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      local virt_text = require("nvim-dap-virtual-text")
      virt_text.setup{} 
      virt_text.enable()
    end
  },
  {
    'mfussenegger/nvim-dap',
    event = "VeryLazy",
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        automatic_installation = true,
        automatic_setup = true,
        handlers = {},
        ensure_installed = { 'delve', },
      }

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        -- icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        -- controls = {
        --   icons = {
        --     pause = '⏸',
        --     play = '▶',
        --     step_into = '⏎',
        --     step_over = '⏭',
        --     step_out = '⏮',
        --     step_back = 'b',
        --     run_last = '▶▶',
        --     terminate = '⏹',
        --     disconnect = '⏏',
        --   },
        -- },
      }

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
      vim.keymap.set('n', '<F8>', dapui.eval, { desc = 'Debug: See last session result.' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      -- require('dap-go').setup()
    end,
  },
}
