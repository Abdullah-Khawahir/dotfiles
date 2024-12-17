-- vim options
vim.g.mapleader        = ' '
vim.g.maplocalleader   = ' '
vim.g.have_nerd_font   = true
vim.o.wrap             = false
vim.o.colorcolumn      = '80'
vim.o.tabstop          = 4
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.mouse          = 'a'
vim.opt.termguicolors  = true
vim.opt.showmode       = false
vim.opt.clipboard      = 'unnamedplus'
vim.opt.breakindent    = true
vim.opt.undofile       = true
vim.opt.termbidi       = true
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.signcolumn     = 'yes'
vim.opt.updatetime     = 100
vim.opt.timeoutlen     = 500
vim.opt.splitright     = true
vim.opt.splitbelow     = true
vim.opt.list           = true
vim.opt.listchars      = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand     = 'split'
vim.opt.cursorline     = true
vim.opt.scrolloff      = 10
vim.opt.hlsearch       = true
vim.opt.linebreak      = true
-- vim.opt.path           = vim.opt.path + '**'
-- vim.opt.path           = vim.opt.path - 'node_modules/**'
vim.cmd("set path+=**")

vim.cmd("packadd cfilter")

--netrw
vim.g.netrw_banner          = 1
vim.g.netrw_fastbrowse      = 0
vim.g.netrw_keepdir         = 1
vim.g.netrw_localcopydircmd = 'cp -r'
vim.g.netrw_winsize         = 30
vim.g.netrw_preview         = 1
vim.g.netrw_winsize         = 30
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.bo.bufhidden = "wipe"
  end,
})

-- compilers
--  dotnet
vim.g.dotnet_errors_only = true
-- flutter
-- vim.g.dart_sdk_path = "/path/to/flutter/bin/cache/dart-sdk"
