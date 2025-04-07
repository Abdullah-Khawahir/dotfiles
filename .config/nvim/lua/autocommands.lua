vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})



local function set_keymap(run_command, compiler, opt)
    opt = opt or {}
    local lua_run_command = ":lua OpenTerm('" .. run_command .. (opt.run_command_opt or '') .. "')<CR>"
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>m", lua_run_command,
        { desc = "Run [M]ake Program", noremap = true, silent = true })

    vim.cmd('compiler ' .. compiler)
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>wb", ":make" .. (opt.compiler_opt or '') .. "<CR>",
        { desc = "Run WorkSpace [B]uild" })
end



-- vim.api.nvim_create_autocmd('FileType', {
-- 	pattern = { 'lua' },
-- 	callback = function()
-- 		vim.lsp.start({
-- 			name = "lua-language-server",
-- 			cmd = { "lua-language-server" },
-- 			root_dir = vim.fs.dirname(vim.fs.find({ ".luarc.json", "init.lua" }, { upward = true })[1]),
-- 			settings = {
-- 				Lua = {
-- 					runtime = {
-- 						version = 'LuaJIT',
-- 						path = vim.split(package.path, ';'),
-- 					},
-- 					diagnostics = {
-- 						globals = { 'vim' },
-- 					},
-- 					workspace = {
-- 						library = {
-- 							[vim.fn.expand('$VIMRUNTIME/lua')] = true,
-- 							[vim.fn.stdpath('config') .. '/lua'] = true,
-- 						},
-- 						checkThirdParty = true,
-- 					},
-- 					telemetry = {
-- 						enable = false,
-- 					},
-- 				},
-- 			},
-- 		})
-- 	end,
-- })

vim.api.nvim_create_autocmd('fileType', { -- csharp
    pattern = { 'cs' },
    callback = function()
        local run_command = "dotnet run"
        local compiler = "dotnet"
        set_keymap(run_command, compiler)
    end
})


vim.api.nvim_create_autocmd('fileType', { -- javascipt typescrip
    pattern = { 'js', 'jsx', 'tsx', 'javascript', 'javascriptreact', 'typescriptreact' },
    callback = function()
        local run_command = 'npm run start'
        local compiler = 'eslint'
        set_keymap(run_command, compiler, { compiler_opt = " . " })
    end
})

vim.api.nvim_create_autocmd('fileType', { -- typescrip
    pattern = { 'ts', 'typescript' },
    callback = function()
        local run_command = 'tsc; npm run start'
        local compiler = 'tsc'
        set_keymap(run_command, compiler)
    end
})

vim.api.nvim_create_autocmd('fileType', { -- go
    pattern = { 'go' },
    callback = function()
        local run_command = "go run"
        local compiler = "go"
        set_keymap(run_command, compiler, { run_command_opt = " ./cmd/app" })
    end
})


vim.api.nvim_create_autocmd('fileType', { -- rust
    pattern = { 'rust' },
    callback = function()
        local run_command = "cargo run"
        local compiler = "rustc"
        set_keymap(run_command, compiler)
    end
})


vim.api.nvim_create_autocmd('fileType', { -- python
    pattern = { 'python' },
    callback = function()
        local run_command = "python3 %"
        local compiler = "pylint"
        set_keymap(run_command, compiler)
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>i", ':PyrightOrganizeImports<CR>',
        { desc = "Organize Imports"})
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>f", ':!black -q %<CR>',
        { desc = "format buffer"})
        vim.cmd([[
        setlocal formatprg=black\ -q\ -
        ]])
    end
})
