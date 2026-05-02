-- terminal
local term_buf = nil
local term_win = nil

function OpenTerm(cmd)
  cmd = cmd or ''

  if term_win and vim.api.nvim_win_is_valid(term_win) then
    pcall(vim.api.nvim_win_close, term_win, true)
    term_win = nil
    return
  end

  vim.cmd 'botright split'
  vim.cmd 'resize 15'

  term_win = vim.api.nvim_get_current_win()

  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd('terminal ' .. cmd)
    term_buf = vim.api.nvim_get_current_buf()
  else
    vim.api.nvim_win_set_buf(term_win, term_buf)
  end

  -- vim.cmd("startinsert")
end

vim.keymap.set({ 'n', 't' }, '<C-`>', OpenTerm, { desc = 'Toggle Terminal' })
vim.keymap.set({ 'n', 't' }, '<F1>', OpenTerm, { desc = 'Toggle Terminal' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
  end,
})
