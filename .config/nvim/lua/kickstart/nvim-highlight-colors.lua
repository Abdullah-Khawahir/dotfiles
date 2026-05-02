return {
  'brenoprata10/nvim-highlight-colors',
  opts = {},
  config = function()
    local plugin = require 'nvim-highlight-colors'
    plugin.setup {
      render = 'virtual',
      virtual_symbol_position = 'eol',
      virtual_symbol = '█████████', -- pink #AA00FF ⬤ 🌑 █
      virtual_symbol_prefix = ' ',
    }
    plugin.turnOn()
    vim.keymap.set('n', '<leader>tc', plugin.toggle, { desc = 'toggle highlight color' })
  end,
}
