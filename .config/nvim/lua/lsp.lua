vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end

        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
        map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        map('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
        map('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>f', function()
            vim.lsp.buf.format()
        end, '[F]ormat Buffer')
        map('<leader>H', vim.lsp.buf.typehierarchy, 'Type [H]ierarchy')
        map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[A]dd Workspace folder')
        vim.keymap.set('n', '<leader>wd', function()
            vim.diagnostic.setqflist()
        end, { desc = 'Workspace [d]iagnostic', buffer = event.buf })

        vim.keymap.set('n', '<leader>we', function()
            vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
        end, { desc = 'Workspace [d]iagnostic [e]rrors', buffer = event.buf })

        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Hover Documentation in insert mode' })

        map('<leader>td', function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        end, '[T]oggle [D]iagnostic')

        if client.name == "csharp_ls" or client.name == "omnisharp" then
            map('gd', function() require('omnisharp_extended').lsp_definition() end,
                '[G]oto [D]efinition+')
            map('gD', require('omnisharp_extended').lsp_type_definition, '[G]oto [D]efinition+')
            map('gr', require('omnisharp_extended').lsp_references, '[G]oto [R]eferences+')
            map('gI', require('omnisharp_extended').lsp_implementation, '[G]oto [I]mplementation+')
        end


        if client.name == "tsserver" or client.name == "ts_ls" then
            map('<leader>i', function()
                vim.lsp.buf.execute_command({
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                    title = ""
                })
            end, 'Organize [I]mports')
        end

        if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end

        local project_root = client.config.root_dir
        if project_root then
            vim.cmd('setlocal path=' .. project_root)
            vim.cmd('setlocal path+=' .. project_root .. '/**')
        end

        if client.server_capabilities.documentHighlightProvider then
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

        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(true)
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
        end
    end,
})
