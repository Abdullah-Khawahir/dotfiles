vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })


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
	callback = function(bufn)
		vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<CR><C-w>p', { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':copen<CR>', { desc = 'Open Quickfix window', silent = true })
		vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':cclose<CR>', { desc = '[Q]uit Quickfix', silent = true })
		vim.api.nvim_buf_set_keymap(0, 'n', 'da', ':call setqflist([], "r")<CR>', { desc = 'Clear Quickfix list', silent = true })

		-- delete currnet line in quickfix
		-- vim.keymap.set('n', 'dd', function()
		-- 	local qflist = vim.fn.getqflist()
		-- 	local current_entry = vim.fn.line('.')
		-- 	table.remove(qflist, current_entry)
		-- 	vim.fn.setqflist(qflist, 'r')
		-- end, { desc = 'Delete current Quickfix entry' })
	end
})


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

vim.api.nvim_set_keymap('n', '<C-i>', '<C-i>', { noremap = true, silent = true })

-- -- util functions
-- vim.keymap.set('n', '<leader>f', function()
-- 	local functions = require('fn')
-- 	local telescope = require('telescope')
-- 	local actions = require('telescope.actions')
-- 	local action_state = require('telescope.actions.state')
-- 	telescope.extensions.fzf_writer = require('telescope._extensions.fzf_writer')
-- 	telescope.setup {
-- 		defaults = {
-- 			mappings = {
-- 				i = {
-- 					["<CR>"] = function(prompt_bufnr)
-- 						local selection = action_state.get_selected_entry(prompt_bufnr)
-- 						actions.close(prompt_bufnr)
-- 						functions[selection.value]()
-- 					end,
-- 				},
-- 			},
-- 		},
-- 	}
--
-- 	telescope.extensions.fzf_writer.staged_grep {
-- 		prompt_title = 'Function Picker',
-- 		entry_maker = function(entry)
-- 			return {
-- 				value = entry,
-- 				display = entry,
-- 				ordinal = entry,
-- 			}
-- 		end,
-- 	}
-- end, { desc = 'Util [f]unctions' })
--

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


vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
