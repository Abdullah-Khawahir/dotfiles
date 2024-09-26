-- terminal
local ACTIVE_TERM = nil;
function OpenTerm(args)
  local bufnr = vim.api.nvim_get_current_buf()
  if bufnr == ACTIVE_TERM then
    vim.cmd("clo")
  else
    if ACTIVE_TERM == nil or not vim.api.nvim_buf_is_valid(ACTIVE_TERM) then
      vim.cmd("vsplit | term " .. (args or ""))
      vim.cmd("wincmd 20<")
      ACTIVE_TERM = vim.api.nvim_get_current_buf()
    else
      vim.cmd("vsplit")
      vim.cmd("wincmd 20<")
      vim.api.nvim_set_current_buf(ACTIVE_TERM)
    end
  end
end

vim.keymap.set({ 'n', 't' }, '<C-`>', function()
  OpenTerm()
end, { desc = "Toggle Terminal" })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

