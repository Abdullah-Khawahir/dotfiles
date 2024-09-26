require("options")

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
      'folke/tokyonight.nvim',
      priority = 1000, -- Make sure to load this before all the other start plugins.
      init = function()
        vim.cmd.colorscheme 'tokyonight-night'
        vim.cmd.hi 'Comment gui=none'
      end,
    },
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    'tpope/vim-fugitive',
    'numToStr/Comment.nvim',
    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
    require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
    'lewis6991/gitsigns.nvim',
    {                                     -- Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      event = 'VimEnter',                 -- Sets the loading event to 'VimEnter'
      config = function()                 -- This is the function that runs, AFTER loading
        require('which-key').setup()
        require('which-key').add {
          { '<leader>c', group = '[C]ode' },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>h', group = 'Git [H]unk' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>o', group = '[O]pen' },
        }
        -- visual mode
        require('which-key').add({
            { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
          },
          { mode = 'v' }
        )
      end,
    },
    { -- Fuzzy Finder (files, lsp, etc)
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
      },
      config = function()
        --  - Insert mode: <c-/>
        --  - Normal mode: ?
        require('telescope').setup {
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
          },
          defaults = {
            path_display = { "smart" },
            file_ignore_patterns = {
              'node_modules',
              'bin',
              'obj',
              '%.png',
              '%.jpg',
              '%.jpg',
            },
          },
        }
        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', function()
            builtin.find_files { path_display = { "smart" } }
          end,
          { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sw', function()
            builtin.grep_string { opts = { path_display = { "smart" } } }
          end,
          { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', function()
          builtin.live_grep { opts = { path_display = { "smart" } } }
        end, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>sc', builtin.git_status, { desc = 'Git [C]hanged' })

        vim.keymap.set('n', '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = '[/] Fuzzily search in current buffer' })

        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end, { desc = '[S]earch [/] in Open Files' })

        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files { cwd = '~/dotfiles/.config/nvim/' }
        end, { desc = '[S]earch [N]eovim files' })
      end,
    },
    { -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'Hoffs/omnisharp-extended-lsp.nvim',
        -- Useful status updates for LSP.
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim',       opts = {} },
        -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        { 'folke/neodev.nvim',       opts = {} },
        'mfussenegger/nvim-jdtls',
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

            map('<leader>f', vim.lsp.buf.format, '[F]ormat Buffer')

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
            vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
            -- Opens a popup that displays documentation about the word under your cursor
            --  See `:help K` for why this keymap.
            map('K', vim.lsp.buf.hover, 'Hover Documentation')
            vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Hover Documentation in insert mode' })
            -- WARN: This is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header.
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            --
            --
            if client ~= nil and (client.name == "csharp_ls" or client.name == "omnisharp") then
              map('gd', function() require('omnisharp_extended').telescope_lsp_definition() end,
                '[G]oto [D]efinition+')
              map('gD', require('omnisharp_extended').telescope_lsp_type_definition, '[G]oto [D]efinition+')
              map('gr', require('omnisharp_extended').telescope_lsp_references, '[G]oto [R]eferences+')
              map('gI', require('omnisharp_extended').telescope_lsp_implementation, '[G]oto [I]mplementation+')
            end


            if client ~= nil and client.name == "tsserver" then
              map('<leader>i', function()
                vim.lsp.buf.execute_command({
                  command = "_typescript.organizeImports",
                  arguments = { vim.api.nvim_buf_get_name(0) },
                  title = ""
                })
              end, 'Organize [I]mports')
            end

            if client and client.server_capabilities.documentHighlightProvider then
              local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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

            map('<leader>td', function()
              vim.diagnostic.enable(not vim.diagnostic.is_enabled())
            end, '[T]oggle [D]iagnostic')
            -- The following autocommand is used to enable inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(false)
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
              end, '[T]oggle Inlay [H]ints')
            end
          end,
        })
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
        local servers = {
          -- clangd = {}
          -- gopls = {},
          -- pyright = {},
          -- rust_analyzer = {},
          -- tsserver = {},
          lua_ls = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
              },
            },
          },
        }
        require('mason').setup()

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua', -- Used to format Lua code
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              -- This handles overriding only values explicitly passed
              -- by the server configuration above. Useful when disabling
              -- certain features of an LSP (for example, turning off formatting for tsserver)
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    },
    { -- Autocompletion
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
          'L3MON4D3/LuaSnip',
          build = (function()
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
              return
            end
            return 'make install_jsregexp'
          end)(),
          dependencies = {
            {
              'rafamadriz/friendly-snippets',
              config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
              end,
            },
          },
        },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
      },
      config = function()
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}
        cmp.setup {
          view = {
            docs = {
              auto_open = true,
            },
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          completion = { completeopt = 'menu,menuone,noselect' },
          mapping = cmp.mapping.preset.insert {
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-b>'] = function()
              if cmp.visible_docs() then
                cmp.scroll_docs(-4)
              else
                cmp.open_docs()
              end
            end,
            ['<C-f>'] = function()
              if cmp.visible_docs() then
                cmp.scroll_docs(4)
              else
                cmp.open_docs()
              end
            end,
            ['<C-y>'] = cmp.mapping.confirm { select = true },
            ['<CR>'] = cmp.mapping.confirm {},
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<C-Space>'] = function()
              if not cmp.visible() then
                cmp.complete()
              else
                cmp.close()
                cmp.close_docs()
              end
            end,
            ['<C-l>'] = cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' }),
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = 'luasnip' },
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          formatting = {
            format = require("nvim-highlight-colors").format
          },
        }
      end,
    },
    {
      'echasnovski/mini.nvim',
      config = function()
        require('mini.ai').setup { n_lines = 500 }
        local statusline = require 'mini.statusline'
        statusline.setup { use_icons = vim.g.have_nerd_font }
        require 'mini.bracketed'.setup {}
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end
      end,
    },
    { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'ruby' },
        },
      },
      config = function(_, opts)
        require('nvim-treesitter.install').prefer_git = true
        require('nvim-treesitter.configs').setup(opts)
      end,
    },
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      dependencies = { 'hrsh7th/nvim-cmp' },
      config = function()
        require('nvim-autopairs').setup {}
        local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
        local cmp = require 'cmp'
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      end,
    },
    {
      'glepnir/dashboard-nvim',
      requires = { 'nvim-tree/nvim-web-devicons' },
      event = 'VimEnter',
      config = function()
        local headers = require 'headers'
        math.randomseed(os.time())
        local random = math.random(1, #headers)
        require('dashboard').setup {
          theme = 'doom',
          config = {
            header = headers[random],
          },
        }
      end,
    },
    {
      "jackMort/ChatGPT.nvim",
      event = "VeryLazy",
      opts = {},
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        "nvim-telescope/telescope.nvim"
      },
    },
    {
      'brenoprata10/nvim-highlight-colors',
      opts = {
      },
      config = function()
        local plugin = require("nvim-highlight-colors")
        plugin.setup {
          render = 'virtual',
          virtual_symbol_position = 'eol',
          -- virtual_symbol = '🌑',  -- pink #AA00FF
          virtual_symbol_prefix = ' ',
        }
        plugin.turnOff()
        vim.keymap.set('n', '<leader>tc', plugin.toggle, { desc = "toggle highlight color" })
      end
    },
    {
      "oysandvik94/curl.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        local curl = require("curl")
        curl.setup({})
        local function map(key, func, desc)
          vim.keymap.set("n", "<leader>u" .. key, func, { desc = desc })
        end
        map("q", ":CurlClose<CR>", "Open curl tab")
        map("o", curl.open_global_tab, "Open global curl tab")
        map("cl", curl.create_scoped_collection, "Create/Open collection")
        map("cg", curl.create_global_collection, "Create/Open global collection")
        map("sl", curl.pick_scoped_collection, "Choose/Open scoped collection")
        map("sg", curl.pick_scoped_collection, "Choose/Open scoped collection")
      end,
    },
  },
  {
    ui = {
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
    install = { colorscheme = { "habamax" } },
    -- checker = { enabled = true },
    performance = {
      cache = { enabled = true },
      defaults = {
        lazy = false,
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
      }
    },
  }
)
require('mappings')
require('autocommands')
require('terminal')
-- the line beneath this is called `modeline`. see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
