local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local M = {}

M.noLines = function()
  vim.opt.number = false
  vim.opt.signcolumn = 'no'
end

local function namedEntry(func)
  return { name = debug.getinfo(func, "n"), fn = func }
end
local functions = {
  namedEntry(M.noLines)
}



M.select_function = function()
  pickers.new({}, {
    prompt_title = "Select a Function",
    finder = finders.new_table {
      results = functions,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        print("You selected: " .. selection[1])
        selection[1]()
      end)
      return true
    end,
  }):find()
end

return M
