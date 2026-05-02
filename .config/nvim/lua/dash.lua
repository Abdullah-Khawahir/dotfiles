local function configure_buffer_options()
    vim.opt_local.modifiable = false
    vim.opt_local.readonly = true
    vim.opt_local.buflisted = false
    vim.opt_local.cursorline = false
    vim.opt_local.buftype = 'nofile'
    vim.opt_local.swapfile = false
end

local function highlight_lines(start_line, end_line)
    local buf = vim.api.nvim_get_current_buf()
    for i = start_line, end_line do
        vim.api.nvim_buf_add_highlight(buf, -1, 'MoreMsg', i, 0, -1)
    end
end

local function display_random_ascii_art()
    local headers = require 'headers'
    math.randomseed(os.time())
    local random_index = math.random(1, #headers)
    local header = headers[random_index]
    vim.api.nvim_buf_set_lines(0, 0, -1, false, header)
    highlight_lines(0, #header - 1)
end

-- local current_laststatus = vim.o.laststatus

local function start_dashboard()
    vim.cmd('enew')
    local dashbordBuffer = vim.api.nvim_get_current_buf()
    vim.keymap.set('n', 'n', ':enew<CR>', { noremap = true, silent = true, buffer = dashbordBuffer })
    vim.keymap.set('n', ']]', start_dashboard, { noremap = true, silent = true, buffer = dashbordBuffer })
    vim.bo.filetype = 'dash'
    -- vim.o.laststatus = 0
    vim.opt.shortmess:append('F')
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.list = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.colorcolumn = '0'

    display_random_ascii_art()

    local screen_width = vim.api.nvim_win_get_width(0)
    vim.bo.textwidth = screen_width + 1
    vim.cmd(':%center')

    configure_buffer_options()

    vim.api.nvim_create_autocmd("WinEnter", {
        callback = function()
            local buf = vim.api.nvim_get_current_buf()

            -- ignore special buffers
            if vim.bo[buf].buftype ~= "" then
                return
            end

            -- ignore dashboard itself
            if vim.bo[buf].filetype == "dash" then
                return
            end

            if vim.api.nvim_buf_is_valid(dashbordBuffer) then
                vim.api.nvim_buf_delete(dashbordBuffer, { force = true })

            end
        end,
        once = true,
    })
end

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        if #vim.v.argv > 2 then
            return
        end
        start_dashboard()
    end
})
