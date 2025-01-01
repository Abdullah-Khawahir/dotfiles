local function nmap(key, cmd, opt)
    vim.keymap.set('n', key, cmd, opt or { desc = 'No description provided', noremap = true, silent = true })
end

local function imap(key, cmd, opt)
    vim.keymap.set('i', key, cmd, opt or { desc = 'No description provided', noremap = true, silent = true })
end

local function vmap(key, cmd, opt)
    vim.keymap.set('v', key, cmd, opt or { desc = 'No description provided', noremap = true, silent = true })
end

nmap('<Esc>', '<cmd>nohlsearch<CR>')
nmap('<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- save changes / write buffer
nmap('<C-s>', "<cmd>:w<CR>", { silent = true, desc = 'Show diagnostic [E]rror messages' })
nmap(']b', ":bn<CR>", { desc = 'next buffer' })
nmap('[b', ":bp<CR>", { desc = 'previous buffer' })

nmap('ZD', ":bd<CR>", { desc = 'delete buffer' })

imap('<C-s>', "<cmd>:w<CR>a", { silent = true, desc = 'Show diagnostic [E]rror messages' })
nmap('<C-S-s>', ":wa<CR>", { desc = 'Show diagnostic [E]rror messages' })
imap('<C-S-s>', "<Esc>:wa<CR>a", { desc = 'Show diagnostic [E]rror messages' })

nmap('<leader><leader>', ":b ", { desc = 'go to buffer ' })

-- quickfix
nmap(']q', ':cn<CR>', { silent = true })
nmap('[q', ':cp<CR>', { silent = true })
nmap('<leader>q', function()
    if vim.api.nvim_buf_get_option(0, 'buftype') == 'quickfix' then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end, { desc = 'Toggles diagnostic [Q]uickfix list' })
vim.api.nvim_create_augroup('QFKeymaps', { clear = true })

nmap('<leader>C', function() vim.cmd(":!!") end, { desc = 'run last shell command', noremap = true })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    group = "QFKeymaps",
    callback = function(event)
        local bufn = event.buf
        -- nmap( '<CR>', '<CR><C-w>p', { buffer = bufn})
        nmap('q', ':cclose<CR>', { buffer = bufn, desc = '[Q]uit Quickfix', silent = true })
        nmap('da', ':call setqflist([], "r")<CR>',
            { buffer = bufn, desc = 'Clear Quickfix list', silent = true })

        -- delete currnet line in quickfix
        nmap('dd', function()
            local qflist = vim.fn.getqflist()
            local current_entry = vim.fn.line('.')
            table.remove(qflist, current_entry)
            vim.fn.setqflist(qflist, 'r')
        end, { buffer = bufn, desc = 'Delete current Quickfix entry' })

        vim.keymap.set({ 'v', 'x' }, 'd', function()
            local start = vim.fn.getpos("'<")[2]
            local endRange = vim.fn.getpos("'>")[2]

            if start > endRange then
                start, endRange = endRange, start
            end
            local qflist = vim.fn.getqflist()

            for i = endRange, start, -1 do
                table.remove(qflist, i)
                print(i)
            end
            vim.fn.setqflist(qflist, 'r')
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        end, { buffer = bufn, desc = 'Delete Quickfix entries' })
    end
})
vim.keymap.set({ 'n', 'v' }, '<leader>Q', function()
    vim.fn.setqflist({ {
        bufnr = vim.fn.bufnr('%'),
        lnum = vim.fn.line('.'),
        col = 1,
        text = vim.fn.getline('.'),
    } }, 'a')
end
, { desc = "add currnet line to quickfix" })


-- moving
nmap('<left>', '<cmd>echo "Use h to move!!"<CR>')
nmap('<right>', '<cmd>echo "Use l to move!!"<CR>')
nmap('<up>', '<cmd>echo "Use k to move!!"<CR>')
nmap('<down>', '<cmd>echo "Use j to move!!"<CR>')

nmap('<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
nmap('<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
nmap('<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
nmap('<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

nmap('<C-left>', '<C-w>>', { desc = 'resize left' })
nmap('<C-right>', '<C-w><', { desc = 'resize right' })
nmap('<C-down>', '<C-w>-', { desc = 'resize down' })
nmap('<C-up>', '<C-w>+', { desc = 'resize up' })

-- for going one visual line down and up in wrap mode
-- tabs
nmap('<Tab>', "gt")
nmap('<S-Tab>', "gT")
nmap('<C-S-right>', ":+tabmove<CR>")
nmap('<C-S-left>', ":-tabmove<CR>")
nmap('<C-S-T>', ":tabnew<CR>")

-- ux mappings
nmap('<c-d>', '<c-d>zz')
nmap('<c-u>', '<c-u>zz')
nmap('n', 'nzz')
nmap('N', 'Nzz')

-- imap('"', '""<left>', { desc = "autoclosing" })
-- imap("'", "''<left>", { desc = "autoclosing" })
-- imap("`", "``<left>", { desc = "autoclosing" })
-- imap("(", "()<left>", { desc = "autoclosing" })
-- imap("[", "[]<left>", { desc = "autoclosing" })
-- imap("{", "{}<left>", { desc = "autoclosing" })
-- imap("<", "<><left>", { "desc" = "autoclosing" })

vmap('s"', 'di"<C-r>\""', { desc = "autoclosing" })
vmap('s\'', 'di\'<C-r>\"\'', { desc = "autoclosing" })
vmap("s`", "di`<C-r>\"`", { desc = "autoclosing" })
vmap("s(", "di(<C-r>\")", { desc = "autoclosing" })
vmap("s[", "di[<C-r>\"]", { desc = "autoclosing" })
vmap("s{", "di{<C-r>\"}", { desc = "autoclosing" })
vmap("s<", "di<<C-r>\">", { desc = "autoclosing" })

nmap('<leader>pe', vim.cmd.Ntree, { desc = 'opens [E]xplorer' })
nmap('<leader>pv', '<cmd>Vex!<CR>', { desc = 'opens [V]ertical Explorer' })

-- search and find mappings
nmap('<leader>po', ':args **/*', { desc = '[O]pen files using glob' })
nmap('<leader>pt', function()
    vim.cmd(":enew")
    vim.cmd(":%!tree --gitignore -t -r")
    vim.cmd(":setlocal nomodifiable")
    vim.cmd(":set buftype=nofile")
end, { desc = '[O]pen project [t]ree' })
nmap('<leader>sf', ':args **/*', { desc = 'Open [f]iles using glob' })
nmap('<leader>sn', ':args ~/.config/nvim/**/*', { desc = 'Open co[n]fig files using glob' })
-- nmap('<leader>sn', ':args ~/AppData/Local/nvim/**/*', { desc = 'Open co[n]fig files using glob' })
nmap('<leader>sh', ':help ', { desc = 'Open [h]elp' })

nmap('<leader>sw', ":vim// **<Left><Left><Left><Left>",
    { desc = "grep search current word in **" })

nmap('<leader>sw', ":vim/<C-r>=expand('<cword>')<CR>/ **<Left><Left><Left><Left>",
    { desc = "grep search current word in **" })

vmap('gX', '"gy:!xdg-open "https://www.google.com/search?q=<C-R>g"<left>',
    { desc = "Search selected text in Google" })

nmap('gX', '"gy:!xdg-open "https://www.google.com/search?q="<left>',
    { desc = "Google search" })

nmap('<C-i>', '<C-i>', { noremap = true, silent = true })

nmap('<leader>ra', 'yiw:%sno/<C-r>"//gc<Left><Left><Left>', { desc = "Repalce Word in [a]ll lines" })
vmap('<leader>ra', 'y:%sno/<C-r>"//gc<Left><Left><Left>', { desc = "Repalce Word in [a]ll lines" })

nmap('<leader>rc', ":sno/<C-r>=expand('<cword>')<CR>//gc<Left><Left><Left>",
    { desc = "Repalce Word in [c]urrnet line" })
vmap('<leader>rc', '\"sy:sno/<C-r>s//gc<Left><Left><Left>',
    { desc = "Replace Selected in [c]urrent line" })

nmap("<leader>waf", ":e <C-r>=expand('%:p:h')<CR>/", { desc = "Add [F]ile" })
nmap("<leader>wad", ":!mkdir -p <C-r>=expand('%:p:h')<CR>/", { desc = "Add [D]irecory" })


-- toggle mappings
IS_ARABIC = false
nmap('<leader>ta', function()
    if not IS_ARABIC then
        -- vim.cmd ':set arabic'
        vim.cmd ':set termbidi'
        vim.cmd ':set rightleft'
    else
        -- vim.cmd ':set noarabic'
        vim.cmd ':set notermbidi'
        vim.cmd ':set norightleft'
    end
    IS_ARABIC = not IS_ARABIC
end, { desc = '[A]rabic Toggle' })
nmap('<leader>tr', ':set wrap!<CR>', { desc = 'W[r]ap Toggle' })

nmap('\\c', function()
    if vim.o.cmdheight == 0 then
        vim.o.cmdheight = 1
        vim.opt_global.cmdheight = 1
    else
        vim.o.cmdheight = 0
        vim.opt_global.cmdheight = 0
    end
    if vim.o.laststatus == 0 then
        vim.o.laststatus = 2
        vim.opt_global.laststatus = 2
    else
        vim.o.laststatus = 0
        vim.opt_global.laststatus = 0
    end
end, { desc = 'Cmd Toggle' })

nmap('\\r', ':set wrap!<CR>', { desc = 'Wrap Toggle' })
nmap('\\gr', ':windo set wrap!<CR>', { desc = 'Wrap Toggle' })

nmap('\\s', ':set spell!<CR>', { desc = 'spell Toggle' })
nmap('\\gs', ':windo set spell!<CR>', { desc = 'spell Toggle' })

nmap('\\n', ':set rnu! nu!<CR>', { desc = 'Number Toggle' })
nmap('\\gn', ':windo set  rnu! nu!<CR>', { desc = 'Number Toggle' })

nmap('\\e', ':set modifiable!<CR>', { desc = 'toggle modifiable for to make buffer [e]ditable' })

vmap('K', ":m '<-2<CR>gv=gv")
vmap('J', ":m '>+1<CR>gv=gv")
