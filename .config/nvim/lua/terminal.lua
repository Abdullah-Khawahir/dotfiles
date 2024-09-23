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

local programOf = {
  cs = "dotnet run",
  js = "node %",
  go = "go run %",
  rust = "cargo run",
  python = "python3 %",
}
vim.api.nvim_create_autocmd('fileType', {
  pattern = vim.tbl_keys(programOf),
  desc = 'project runner',
  callback = function()
    local fileType = vim.bo.filetype
    if programOf[fileType] then
      local lua_command = ":lua OpenTerm('" .. programOf[fileType] .. "')<CR>"
      -- print(lua_command)
      vim.api.nvim_buf_set_keymap(0, "n", "<leader>m", lua_command,
        { desc = "Run [M]ake Program", noremap = true, silent = true })
      -- vim.bo.makeprg = programOf[fileType]
    end
  end
})
