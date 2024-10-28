vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim.api.nvim_create_autocmd('fileType', {
--   pattern = 'fugitive',
--   callback = function(event)
--     vim.keymap.set('n', '<CR>', "<C-w>p<CR>", { buffer = event.buf })
--   end
-- })

local function set_keymap(run_command, compiler)
  local lua_run_command = ":lua OpenTerm('" .. run_command .. "')<CR>"
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>m", lua_run_command,
    { desc = "Run [M]ake Program", noremap = true, silent = true })

  vim.cmd('compiler ' .. compiler)
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>wb", ":make<CR>",
    { desc = "Run WorkSpace [B]uild" })
end


vim.api.nvim_create_autocmd('fileType', { -- csharp
  pattern = { 'cs' },
  callback = function()
    local run_command = "dotnet run"
    local compiler = "dotnet"
    set_keymap(run_command, compiler)
  end
})


vim.api.nvim_create_autocmd('fileType', { -- javascipt typescrip
  pattern = { 'js', 'jsx', 'ts', 'tsx', 'javascipt', 'javascriptreact', 'typescipt', 'typescriptreact' },
  callback = function()
    local run_command = 'npm run start'
    local compiler = 'eslint'
    set_keymap(run_command, compiler)
  end
})


vim.api.nvim_create_autocmd('fileType', { -- go
  pattern = { 'go' },
  callback = function()
    local run_command = "go run"
    local compiler = "go"
    set_keymap(run_command, compiler)
  end
})


vim.api.nvim_create_autocmd('fileType', { -- rust
  pattern = { 'rust' },
  callback = function()
    local run_command = "cargo run"
    local compiler = "rustrc"
    set_keymap(run_command, compiler)
  end
})


vim.api.nvim_create_autocmd('fileType', { -- python
  pattern = { 'python' },
  callback = function()
    local run_command = "python3 %"
    local compiler = "pylint"
    set_keymap(run_command, compiler)
  end
})
