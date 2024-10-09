vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})



local programOf = { -- retrun 1=compiler 2=run_command
  cs = { "dotnet", "dotnet run" },
  js = { nil, "node %" },
  go = { "go", "go run" },
  rust = { "rustrc", "cargo run" },
  python = { "pylint", "python3 %" },
}
vim.api.nvim_create_autocmd('fileType', {
  pattern = vim.tbl_keys(programOf),
  desc = 'project runner',
  callback = function()
    local fileType = vim.bo.filetype
    local compiler, run_command = programOf[fileType][1], programOf[fileType][2]

    if run_command ~= nil then
      local lua_run_command = ":lua OpenTerm('" .. run_command .. "')<CR>"
      vim.api.nvim_buf_set_keymap(0, "n", "<leader>m", lua_run_command,
        { desc = "Run [M]ake Program", noremap = true, silent = true })
    end

    if compiler ~= nil then
      vim.cmd('compiler ' .. compiler)
      vim.api.nvim_buf_set_keymap(0, "n", "<leader>wb", ":make<CR>",
        { desc = "Run WorkSpace [B]uild" })
    end
  end
})
