vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			if func then
				vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
		map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
		map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
		map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
		map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

		if client.server_capabilities.documentSymbolProvider then
			map('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
		end

		if client.server_capabilities.workspaceSymbolProvider then
			map('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
		end

		map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
		map('<leader>f', vim.lsp.buf.format, '[F]ormat Buffer')
		map('<leader>H', vim.lsp.buf.type_hierarchy, 'Type [H]ierarchy')
		map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[A]dd Workspace folder')

		if client ~= nil and (client.name == "csharp_ls" or client.name == "omnisharp") then
			map('gd', function() require('omnisharp_extended').lsp_definition() end,
				'[G]oto [D]efinition+')
			map('gD', require('omnisharp_extended').lsp_type_definition, '[G]oto [D]efinition+')
			map('gr', require('omnisharp_extended').lsp_references, '[G]oto [R]eferences+')
			map('gI', require('omnisharp_extended').lsp_implementation, '[G]oto [I]mplementation+')
		end

		if client ~= nil and client.name == "tsserver" or client.name == "ts_ls" then
			map('<leader>i', function()
				vim.lsp.buf.execute_command({
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = ""
				})
			end, 'Organize [I]mports')
		end

		if client ~= nil then
			local project_root = client.config.root_dir
			if project_root then
				vim.cmd('setlocal path=' .. project_root)
				vim.cmd('setlocal path+=' .. project_root .. '/**')
			end
		end

		if client and client.server_capabilities.documentHighlightProvider then
			local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight',
				{ clear = false })
			vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd('LspDetach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
				end,
			})
		end

		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			map('<leader>th', function()
				vim.lsp.inlay_hint.enable(true)
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, '[T]oggle Inlay [H]ints')
		end
		print("LSP attached for client: " .. client.name)
	end,
})
