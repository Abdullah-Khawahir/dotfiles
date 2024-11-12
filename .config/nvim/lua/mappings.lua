vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- save changes / write buffer
vim.keymap.set('n', '<C-s>', ":w<CR>", { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('i', '<C-s>', "<Esc>:w<CR>a", { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<C-S-s>', ":wa<CR>", { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('i', '<C-S-s>', "<Esc>:wa<CR>a", { desc = 'Show diagnostic [E]rror messages' })

-- quickfix
vim.keymap.set('n', '<leader>q', function()
	if vim.api.nvim_buf_get_option(0, 'buftype') == 'quickfix' then
		vim.cmd('cclose')
	else
		vim.cmd('copen')
	end
end, { desc = 'Toggles diagnostic [Q]uickfix list' })
vim.api.nvim_create_augroup('QFKeymaps', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'qf',
	group = "QFKeymaps",
	callback = function(event)
		local bufn = event.buf
		-- vim.keymap.set('n', '<CR>', '<CR><C-w>p', { buffer = bufn})
		vim.keymap.set('n', 'q', ':cclose<CR>', { buffer = bufn, desc = '[Q]uit Quickfix', silent = true })
		vim.keymap.set('n', 'da', ':call setqflist([], "r")<CR>',
			{ buffer = bufn, desc = 'Clear Quickfix list', silent = true })

		-- delete currnet line in quickfix
		vim.keymap.set('n', 'dd', function()
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

			print(start)
			print(endRange)
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
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-left>', '<C-w>>', { desc = 'resize left' })
vim.keymap.set('n', '<C-right>', '<C-w><', { desc = 'resize right' })
vim.keymap.set('n', '<C-down>', '<C-w>-', { desc = 'resize down' })
vim.keymap.set('n', '<C-up>', '<C-w>+', { desc = 'resize up' })

-- for going one visual line down and up in wrap mode
-- tabs
vim.keymap.set('n', '<Tab>', "gt")
vim.keymap.set('n', '<S-Tab>', "gT")
vim.keymap.set('n', '<C-S-right>', ":+tabmove<CR>")
vim.keymap.set('n', '<C-S-left>', ":-tabmove<CR>")
vim.keymap.set('n', '<C-S-T>', ":tabnew<CR>")

-- ux mappings
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set('n', '<leader>pe', vim.cmd.Ex, { desc = 'opens [E]xplorer' })
vim.keymap.set('n', '<leader>pv', '<cmd>Vex!<CR>', { desc = 'opens [V]ertical Explorer' })
vim.keymap.set('n', '<leader>po', ':args **/', { desc = '[O]pen files using glob' })


vim.keymap.set('n', '<C-i>', '<C-i>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ra', 'yiw:%sno/<C-r>"//gc<Left><Left><Left>', { desc = "Repalce Word in [a]ll lines" })
vim.keymap.set('v', '<leader>ra', 'y:%sno/<C-r>"//gc<Left><Left><Left>', { desc = "Repalce Word in [a]ll lines" })

vim.keymap.set('n', '<leader>rc', ":sno/<C-r>=expand('<cword>')<CR>//gc<Left><Left><Left>",
	{ desc = "Repalce Word in currnet line" })
vim.keymap.set('v', '<leader>rc', '\"sy:sno/<C-r>s//gc<Left><Left><Left>', { desc = "Replace Selected in current line" })

vim.keymap.set('n', "<leader>waf", ":e <C-r>=expand('%:p:h')<CR>/", { desc = "Add [F]ile" })
vim.keymap.set('n', "<leader>wad", ":!mkdir -p <C-r>=expand('%:p:h')<CR>/", { desc = "Add [D]irecory" })


-- toggle mappings
IS_ARABIC = false
vim.keymap.set('n', '<leader>ta', function()
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
vim.keymap.set('n', '<leader>tr', ':set wrap!<CR>', { desc = 'W[r]ap Toggle' })

vim.keymap.set('n', '\\c', function()
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

vim.keymap.set('n', '\\r', ':set wrap!<CR>', { desc = 'Wrap Toggle' })
vim.keymap.set('n', '\\gr', ':windo set wrap!<CR>', { desc = 'Wrap Toggle' })

vim.keymap.set('n', '\\s', ':set spell!<CR>', { desc = 'spell Toggle' })
vim.keymap.set('n', '\\gs', ':windo set spell!<CR>', { desc = 'spell Toggle' })

vim.keymap.set('n', '\\n', ':set rnu! nu!<CR>', { desc = 'Number Toggle' })
vim.keymap.set('n', '\\gn', ':windo set  rnu! nu!<CR>', { desc = 'Number Toggle' })

vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
