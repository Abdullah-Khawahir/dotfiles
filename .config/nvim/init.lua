require("options")

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('mappings')
require("lsp")
require('lazy').setup({
  require 'kickstart.plugins.debug', -- adds gitsigns recommend keymaps
  -- {
  --   "Jezda1337/nvim-html-css",
  --   dependencies = { "hrsh7th/nvim-cmp", "nvim-treesitter/nvim-treesitter" }, -- Use this if you're using nvim-cmp
  --   -- dependencies = { "saghen/blink.cmp", "nvim-treesitter/nvim-treesitter" }, -- Use this if you're using blink.cmp
  --   opts = {
  --     enable_on = { -- Example file types
  --       "html",
  --       "htmldjango",
  --       "tsx",
  --       "jsx",
  --       "erb",
  --       "svelte",
  --       "vue",
  --       "blade",
  --       "php",
  --       "templ",
  --       "astro",
  --     },
  --     handlers = {
  --       definition = {
  --         bind = "gd"
  --       },
  --       hover = {
  --         bind = "K",
  --         wrap = true,
  --         border = "none",
  --         position = "cursor",
  --       },
  --     },
  --     documentation = {
  --       auto_show = true,
  --     },
  --     style_sheets = {
  --       "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
  --       "https://cdnjs.cloudflare.com/ajax/libs/bulma/1.0.3/css/bulma.min.css",
  --     },
  --   },
  -- },
  {
    "LunarVim/bigfile.nvim",
    config = function()
      -- default config
      require("bigfile").setup {
        filesize = 1,      -- size of the file in MiB, the plugin round file sizes to the closest MiB
        pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
        features = {       -- features to disable
          "indent_blankline",
          "illuminate",
          "lsp",
          "treesitter",
          "syntax",
          "matchparen",
          "vimopts",
          "filetype",
        },
      }
    end
  },
  -- {
  --   'folke/tokyonight.nvim',
  --   event = 'VimEnter', -- Load colorscheme on VimEnter to improve startup time
  --   priority = 1000,    -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     vim.cmd.colorscheme 'tokyonight-night'
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
    opts = ...,
    init = function ()
      vim.cmd.colorscheme 'gruvbox'
      vim.cmd.hi 'Comment gui=none'
    end
  },
  'vifm/vifm.vim',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'windwp/nvim-ts-autotag',
    opts = {
      aliases = {
        ["cshtml"] = "html",
        ["razor"] = "html"
      }
    },
  },
  -- {
  --   'github/copilot.vim',
  --   config = function()
  --     vim.cmd(':Copilot disable')
  --     vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  --       expr = true,
  --       replace_keycodes = false
  --     })
  --   end
  -- },
  {                     -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy', -- or a specific command like 'Telescope'
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
      local telescope = require('telescope')
      local themes = require('telescope.themes')
      local builtin = require('telescope.builtin')

      telescope.setup {
        defaults = {
          file_ignore_patterns = {
            -- 'lib',
            'bin',
            'obj',
            '.git',
            'node_modules',
            '%.png',
            '%.jpg',
            '%.jpg',
            'Migrations'
          },
        }
      }

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      local function nmap(key, cmd, opts)
        vim.keymap.set('n', key, cmd, opts)
      end

      nmap('<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      nmap('<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      nmap('<leader>sf', function()
        builtin.find_files {
          -- path_display = { "smart" } ,

          hidden = false }
      end, { desc = '[S]earch [F]iles' })
      nmap('<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      nmap('<leader>sw', function()
        builtin.grep_string()
      end, { desc = '[S]earch current [W]ord' })
      nmap('<leader>sg', function()
        builtin.live_grep()
      end, { desc = '[S]earch by [G]rep' })
      nmap('<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      nmap('<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      nmap('<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      nmap('<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      nmap('<leader>sc', builtin.git_status, { desc = 'Git [C]hanged' })

      nmap('<leader>/', function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown {
          winblend = 10,
          previewer = false,
          width = 95
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      nmap('<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      nmap('<leader>sn', function()
        builtin.find_files { cwd = '~/dotfiles/.config/nvim/' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = '*', -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      hints = { enabled = false },
      provider = 'openai',
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "o4-mini", -- your desired model (or use gpt-4o, etc.)
          timeout = 30000,   -- Timeout in milliseconds, increase this for reasoning models
          extra_request_body = {
            temperature = 1,
            max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
            reasoning_effort = "medium",  -- low|medium|high, only used for reasoning models
          },
        },
      },
   },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick",         -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",              -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua",          -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            -- use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set("n", "<leader>gs", ":G<CR>", { desc = "Git status" })
      vim.keymap.set("n", "<leader>gc", ":G commit<CR>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gaf", ":G add %<CR>", { desc = "Git add file" })
      vim.keymap.set("n", "<leader>gad", ":G add <C-r>=expand('%:h')<CR>", { desc = "Git add directory" })
      vim.keymap.set("n", "<leader>gac", ":G commit %<CR>", { desc = "Git commit file" })
      vim.keymap.set("n", "<leader>gvd", ":Gvdiffsplit<CR>", { desc = "Git vertical diff split" })
      vim.keymap.set("n", "<leader>gp", ":G push<CR>", { desc = "Git vertical diff split" })
    end
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead', 'BufNewFile' }, -- Load only when reading or creating a file
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
        disable = function(lang, buf)
          local max_filesize = 1024 * 1024 -- 1 MB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)
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
      { 'j-hui/fidget.nvim',       opts = {} },
      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim',       opts = {} },

      'mfussenegger/nvim-jdtls',
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      require('lspconfig').ts_ls.setup({
        init_options = {
          preferences = {
            importModuleSpecifierPreference = 'relative',
            importModuleSpecifierEnding = 'minimal',
          },
        }
      })
      local servers = {
        -- html = {},
        -- clangd = {}
        -- gopls = {},
        black = {},
        -- rust_analyzer = {},
        -- omnisharp = {
        --   enable_roslyn_analyzers = true,
        --   organize_imports_on_format = true,
        --   enable_import_completion = true,
        -- },
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

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
      local lspconfig = require('lspconfig')
      lspconfig.pyright.setup({
        root_dir = lspconfig.util.root_pattern(
          '.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt')
      })
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
              require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/lua/snippets/" })
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
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
        completion = { completeopt = 'menu,menuone,preview,noselect,popup' },
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
          { name = 'buffer' },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          -- format = require("nvim-highlight-colors").format
        },
      }
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      {
        "folke/trouble.nvim",
        config = true
      },
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("chatgpt").setup({
        openai_params = {
          model = "gpt-4-1106-preview",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4095,
          temperature = 0.2,
          top_p = 0.1,
          n = 1,
        }
      })
      local map = function(modes, key, cmd, descrp)
        vim.keymap.set(modes, "<leader>c" .. key, cmd, { desc = "GPT: " .. descrp })
      end

      map({ "n", "v" }, 'c', "<cmd>ChatGPT<CR>", "ChatGPT")
      map({ "n", "v" }, 'e', "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction")
      map({ "n", "v" }, 'g', "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction")
      map({ "n", "v" }, 't', "<cmd>ChatGPTRun translate<CR>", "Translate")
      map({ "n", "v" }, 'd', "<cmd>ChatGPTRun docstring<CR>", "Docstring")
      map({ "n", "v" }, 'o', "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code")
      map({ "n", "v" }, 'f', "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs")
      map({ "n", "v" }, 'r', "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit")
      map({ "n", "v" }, 'l', "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis")
      map({ "n", "v" }, 'h', "<cmd>ChatGPTRun explain_code<CR>", "Code Explaination")
    end
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
      require('flutter-tools').setup {
        lsp = {
          on_attach = function()
            vim.api.nvim_set_keymap('n', '<leader>pr', ":FlutterRun<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pe', ":FlutterEmulators<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pq', ":FlutterQuit<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pd', ":FlutterDevices<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pR', ":FlutterRestart<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pa', ":FlutterReanalyze<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>po', ":FlutterOutlineToggle<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pl', ":FlutterLspRestart<CR>", { noremap = true, silent = true })
          end,
          capabilities = require('cmp_nvim_lsp').default_capabilities(), -- for nvim-cmp (optional)
          init_options = {
            closingLabels = true,                                        -- Show closing labels in code
          },
        },
      }
    end,
  }
})

-- require('lazy').setup({
--     {
--       'folke/tokyonight.nvim',
--       event = 'VimEnter', -- Load colorscheme on VimEnter to improve startup time
--       -- priority = 1000, -- Make sure to load this before all the other start plugins.
--       init = function()
--         vim.cmd.colorscheme 'tokyonight-night'
--         vim.cmd.hi 'Comment gui=none'
--       end,
--     },
--     'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
--     'tpope/vim-surround',
--     'tpope/vim-repeat',
--     {
--       'tpope/vim-fugitive',
--       config = function()
--         vim.keymap.set("n", "<leader>gs", ":G<CR>", { desc = "Git status" })
--         vim.keymap.set("n", "<leader>gc", ":G commit<CR>", { desc = "Git commit" })
--         vim.keymap.set("n", "<leader>gaf", ":G add %<CR>", { desc = "Git add file" })
--         vim.keymap.set("n", "<leader>gad", ":G add <C-r>=expand('%:h')<CR>", { desc = "Git add directory" })
--         vim.keymap.set("n", "<leader>gac", ":G commit %<CR>", { desc = "Git commit file" })
--         vim.keymap.set("n", "<leader>gvd", ":Gvdiffsplit<CR>", { desc = "Git vertical diff split" })
--       end
--     },
--     'numToStr/Comment.nvim',
--     'windwp/nvim-ts-autotag',
--     -- Highlight todo, notes, etc in comments
--     { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
--     require 'kickstart.plugins.gitsigns',    -- adds gitsigns recommend keymaps
--     require 'kickstart.plugins.debug',       -- adds gitsigns recommend keymaps
--     require 'kickstart.plugins.indent_line', -- adds gitsigns recommend keymaps
--     {
--       'lewis6991/gitsigns.nvim',
--       event = { 'BufRead', 'BufNewFile' }, -- Load only when reading or creating a file
--     },
--     {                                      -- Useful plugin to show you pending keybinds.
--       'folke/which-key.nvim',
--       event = 'VimEnter',                  -- Sets the loading event to 'VimEnter'
--       config = function()                  -- This is the function that runs, AFTER loading
--         require('which-key').setup()
--         require('which-key').add {
--           { '<leader>c', group = '[C]ode' },
--           { '<leader>d', group = '[D]ocument' },
--           { '<leader>h', group = 'Git [H]unk' },
--           { '<leader>r', group = '[R]ename' },
--           { '<leader>s', group = '[S]earch' },
--           { '<leader>t', group = '[T]oggle' },
--           { '<leader>w', group = '[W]orkspace' },
--           { '<leader>o', group = '[O]pen' },
--         }
--         -- visual mode
--         require('which-key').add({
--             { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
--           },
--           { mode = 'v' }
--         )
--       end,
--     },
--     {                     -- Fuzzy Finder (files, lsp, etc)
--       'nvim-telescope/telescope.nvim',
--       event = 'VeryLazy', -- or a specific command like 'Telescope'
--       -- event = 'VimEnter',
--       branch = '0.1.x',
--       dependencies = {
--         'nvim-lua/plenary.nvim',
--         {
--           'nvim-telescope/telescope-fzf-native.nvim',
--           build = 'make',
--           cond = function()
--             return vim.fn.executable 'make' == 1
--           end,
--         },
--         { 'nvim-telescope/telescope-ui-select.nvim' },
--         { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
--         -- { "nvim-telescope/telescope-github.nvim" },
--       },
--       config = function()
--         --  - Insert mode: <c-/>
--         --  - Normal mode: ?
--         require('telescope').setup {
--           extensions = {
--             ['ui-select'] = {
--               require('telescope.themes').get_dropdown(),
--             },
--           },
--           defaults = {
--             -- path_display = { "smart" },
--             file_ignore_patterns = {
--               'lib',
--               '.git',
--               'node_modules',
--               'bin',
--               'obj',
--               '%.png',
--               '%.jpg',
--               '%.jpg',
--               'Migrations'
--             },
--           },
--         }
--         -- Enable Telescope extensions if they are installed
--         pcall(require('telescope').load_extension, 'fzf')
--         pcall(require('telescope').load_extension, 'ui-select')
--         -- pcall(require('telescope').load_extension, 'gh')
--         -- require('telescope').load_extension('gh')
--         local builtin = require 'telescope.builtin'
--         vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
--         vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
--         vim.keymap.set('n', '<leader>sf', function()
--             builtin.find_files {
--               -- path_display = { "smart" },
--               hidden = true,
--
--             }
--           end,
--           { desc = '[S]earch [F]iles' })
--         vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
--         vim.keymap.set('n', '<leader>sw', function()
--             builtin.grep_string { opts = {
--               -- path_display = { "smart" }
--             }
--             }
--           end,
--           { desc = '[S]earch current [W]ord' })
--         vim.keymap.set('n', '<leader>sg', function()
--           builtin.live_grep { opts = { path_display = { "smart" } } }
--         end, { desc = '[S]earch by [G]rep' })
--         vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
--         vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
--         vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
--         vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
--         vim.keymap.set('n', '<leader>sc', builtin.git_status, { desc = 'Git [C]hanged' })
--
--         vim.keymap.set('n', '<leader>/', function()
--           builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--             winblend = 10,
--             previewer = false,
--           })
--         end, { desc = '[/] Fuzzily search in current buffer' })
--
--         vim.keymap.set('n', '<leader>s/', function()
--           builtin.live_grep {
--             grep_open_files = true,
--             prompt_title = 'Live Grep in Open Files',
--           }
--         end, { desc = '[S]earch [/] in Open Files' })
--
--         vim.keymap.set('n', '<leader>sn', function()
--           builtin.find_files { cwd = '~/dotfiles/.config/nvim/' }
--         end, { desc = '[S]earch [N]eovim files' })
--       end,
--     },
--     { -- LSP Configuration & Plugins
--       'neovim/nvim-lspconfig',
--       dependencies = {
--         -- Automatically install LSPs and related tools to stdpath for Neovim
--         { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
--         'williamboman/mason-lspconfig.nvim',
--         'WhoIsSethDaniel/mason-tool-installer.nvim',
--         'Hoffs/omnisharp-extended-lsp.nvim',
--         -- Useful status updates for LSP.
--         { 'j-hui/fidget.nvim',       opts = {} },
--         -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
--         -- used for completion, annotations and signatures of Neovim apis
--         { 'folke/neodev.nvim',       opts = {} },
--
--         'mfussenegger/nvim-jdtls',
--       },
--       config = function()
--         vim.api.nvim_create_autocmd('LspAttach', {
--           group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--           callback = function(event)
--             local map = function(keys, func, desc)
--               vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--             end
--
--             local client = vim.lsp.get_client_by_id(event.data.client_id)
--
--             map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
--             map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--             map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--             map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--             map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
--             map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--             map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--             map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--             map('<leader>f', vim.lsp.buf.format, '[F]ormat Buffer')
--             map('<leader>H', vim.lsp.buf.typehierarchy, 'Type [H]ierarchy')
--             map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[A]dd Workspace folder')
--             vim.keymap.set('n', '<leader>wd', function()
--               vim.diagnostic.setqflist()
--             end, { desc = 'Workspace [d]iagnostic', buffer = event.buf })
--
--             vim.keymap.set('n', '<leader>we', function()
--               vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
--             end, { desc = 'Workspace [d]iagnostic [e]rrors', buffer = event.buf })
--
--             map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
--             vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
--
--             map('K', vim.lsp.buf.hover, 'Hover Documentation')
--             vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Hover Documentation in insert mode' })
--
--             map('<leader>td', function()
--               vim.diagnostic.enable(not vim.diagnostic.is_enabled())
--             end, '[T]oggle [D]iagnostic')
--
--             if client ~= nil and (client.name == "csharp_ls" or client.name == "omnisharp") then
--               map('gd', function() require('omnisharp_extended').telescope_lsp_definition() end,
--                 '[G]oto [D]efinition+')
--               map('gD', require('omnisharp_extended').telescope_lsp_type_definition, '[G]oto [D]efinition+')
--               map('gr', require('omnisharp_extended').telescope_lsp_references, '[G]oto [R]eferences+')
--               map('gI', require('omnisharp_extended').telescope_lsp_implementation, '[G]oto [I]mplementation+')
--             end
--
--
--             if client ~= nil and client.name == "tsserver" or client.name == "ts_ls" then
--               map('<leader>i', function()
--                 vim.lsp.buf.execute_command({
--                   command = "_typescript.organizeImports",
--                   arguments = { vim.api.nvim_buf_get_name(0) },
--                   title = ""
--                 })
--               end, 'Organize [I]mports')
--             end
--             if client ~= nil then -- add project files to path
--               local project_root = client.config.root_dir
--               -- Clear existing path and add only the project root to path
--               if project_root then
--                 vim.cmd('setlocal path=' .. project_root)
--                 -- Optionally, include all subdirectories in the project
--                 vim.cmd('setlocal path+=' .. project_root .. '/**')
--               end
--             end
--             if client and client.server_capabilities.documentHighlightProvider then
--               local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--               vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--                 buffer = event.buf,
--                 group = highlight_augroup,
--                 callback = vim.lsp.buf.document_highlight,
--               })
--
--               vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--                 buffer = event.buf,
--                 group = highlight_augroup,
--                 callback = vim.lsp.buf.clear_references,
--               })
--
--               vim.api.nvim_create_autocmd('LspDetach', {
--                 group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--                 callback = function(event2)
--                   vim.lsp.buf.clear_references()
--                   vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--                 end,
--               })
--             end
--
--             if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
--               map('<leader>th', function()
--                 vim.lsp.inlay_hint.enable(true)
--                 vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
--               end, '[T]oggle Inlay [H]ints')
--             end
--           end,
--         })
--         local capabilities = vim.lsp.protocol.make_client_capabilities()
--         capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
--         require('lspconfig').ts_ls.setup({
--           init_options = {
--             preferences = {
--               importModuleSpecifierPreference = 'relative',
--               importModuleSpecifierEnding = 'minimal',
--             },
--           }
--         })
--         local servers = {
--           -- clangd = {}
--           gopls = {},
--           -- pyright = {},
--           -- rust_analyzer = {},
--           lua_ls = {
--             settings = {
--               Lua = {
--                 completion = {
--                   callSnippet = 'Replace',
--                 },
--               },
--             },
--           },
--         }
--         require('mason').setup()
--
--         local ensure_installed = vim.tbl_keys(servers or {})
--         vim.list_extend(ensure_installed, {
--           'stylua', -- Used to format Lua code
--         })
--         require('mason-tool-installer').setup { ensure_installed = ensure_installed }
--         require('mason-lspconfig').setup {
--           handlers = {
--             function(server_name)
--               local server = servers[server_name] or {}
--               server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--               require('lspconfig')[server_name].setup(server)
--             end,
--           },
--         }
--       end,
--     },
--     { -- Autocompletion
--       'hrsh7th/nvim-cmp',
--       event = 'InsertEnter',
--       dependencies = {
--         -- Snippet Engine & its associated nvim-cmp source
--         {
--           'L3MON4D3/LuaSnip',
--           build = (function()
--             if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--               return
--             end
--             return 'make install_jsregexp'
--           end)(),
--           dependencies = {
--             {
--               'rafamadriz/friendly-snippets',
--               config = function()
--                 require('luasnip.loaders.from_vscode').lazy_load()
--                 require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/lua/snippets/" })
--               end,
--             },
--           },
--         },
--         'saadparwaiz1/cmp_luasnip',
--         'hrsh7th/cmp-nvim-lsp',
--         'hrsh7th/cmp-path',
--       },
--       config = function()
--         local cmp = require 'cmp'
--         local luasnip = require 'luasnip'
--         cmp.setup {
--           view = {
--             docs = {
--               auto_open = true,
--             },
--           },
--           window = {
--             completion = cmp.config.window.bordered(),
--             documentation = cmp.config.window.bordered(),
--           },
--           completion = { completeopt = 'menu,menuone,preview,noselect,popup' },
--           mapping = cmp.mapping.preset.insert {
--             ['<C-n>'] = cmp.mapping.select_next_item(),
--             ['<C-p>'] = cmp.mapping.select_prev_item(),
--             ['<C-b>'] = function()
--               if cmp.visible_docs() then
--                 cmp.scroll_docs(-4)
--               else
--                 cmp.open_docs()
--               end
--             end,
--             ['<C-f>'] = function()
--               if cmp.visible_docs() then
--                 cmp.scroll_docs(4)
--               else
--                 cmp.open_docs()
--               end
--             end,
--             ['<C-y>'] = cmp.mapping.confirm { select = true },
--             ['<CR>'] = cmp.mapping.confirm {},
--             ['<Tab>'] = cmp.mapping.select_next_item(),
--             ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--             ['<C-Space>'] = function()
--               if not cmp.visible() then
--                 cmp.complete()
--               else
--                 cmp.close()
--                 cmp.close_docs()
--               end
--             end,
--             ['<C-l>'] = cmp.mapping(function()
--               if luasnip.expand_or_locally_jumpable() then
--                 luasnip.expand_or_jump()
--               end
--             end, { 'i', 's' }),
--             ['<C-h>'] = cmp.mapping(function()
--               if luasnip.locally_jumpable(-1) then
--                 luasnip.jump(-1)
--               end
--             end, { 'i', 's' }),
--           },
--           sources = {
--             { name = 'nvim_lsp' },
--             { name = 'path' },
--             { name = 'luasnip' },
--             { name = 'buffer' },
--           },
--           snippet = {
--             expand = function(args)
--               luasnip.lsp_expand(args.body)
--             end,
--           },
--           formatting = {
--             format = require("nvim-highlight-colors").format
--           },
--         }
--       end,
--     },
--     {
--       'echasnovski/mini.nvim',
--       config = function()
--         require('mini.ai').setup { n_lines = 500 }
--         local statusline = require 'mini.statusline'
--         statusline.setup { use_icons = vim.g.have_nerd_font }
--         require 'mini.bracketed'.setup {}
--         ---@diagnostic disable-next-line: duplicate-set-field
--         statusline.section_location = function()
--           return '%2l:%-2v'
--         end
--       end,
--     },
--     { -- Highlight, edit, and navigate code
--       'nvim-treesitter/nvim-treesitter',
--       build = ':TSUpdate',
--       opts = {
--         ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
--         auto_install = false,
--         highlight = {
--           enable = true,
--           additional_vim_regex_highlighting = { 'ruby' },
--         },
--       },
--       config = function(_, opts)
--         require('nvim-treesitter.install').prefer_git = true
--         require('nvim-treesitter.configs').setup(opts)
--       end,
--     },
--     {
--       'windwp/nvim-autopairs',
--       event = 'InsertEnter',
--       dependencies = { 'hrsh7th/nvim-cmp' },
--       config = function()
--         require('nvim-autopairs').setup {}
--         local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
--         local cmp = require 'cmp'
--         cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
--       end,
--     },
--     {
--       "jackMort/ChatGPT.nvim",
--       event = "VeryLazy",
--       dependencies = {
--         "MunifTanjim/nui.nvim",
--         "nvim-lua/plenary.nvim",
--         {
--           "folke/trouble.nvim",
--           config = true
--         },
--         "nvim-telescope/telescope.nvim"
--       },
--       config = function()
--         require("chatgpt").setup({
--           openai_params = {
--             -- NOTE: model can be a function returning the model name
--             -- this is useful if you want to change the model on the fly
--             -- using commands
--             -- Example:
--             -- model = function()
--             --     if some_condition() then
--             --         return "gpt-4-1106-preview"
--             --     else
--             --         return "gpt-3.5-turbo"
--             --     end
--             -- end,
--             -- model = "gpt-4o",
--             frequency_penalty = 0,
--             presence_penalty = 0,
--             max_tokens = 4095,
--             temperature = 0.2,
--             top_p = 0.1,
--             n = 1,
--           }
--         })
--         local map = function(modes, key, cmd, descrp)
--           vim.keymap.set(modes, "<leader>c" .. key, cmd, { desc = "GPT: " .. descrp })
--         end
--
--         map({ "n", "v" }, 'c', "<cmd>ChatGPT<CR>", "ChatGPT")
--         map({ "n", "v" }, 'e', "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction")
--         map({ "n", "v" }, 'g', "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction")
--         map({ "n", "v" }, 't', "<cmd>ChatGPTRun translate<CR>", "Translate")
--         map({ "n", "v" }, 'd', "<cmd>ChatGPTRun docstring<CR>", "Docstring")
--         map({ "n", "v" }, 'o', "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code")
--         map({ "n", "v" }, 'f', "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs")
--         map({ "n", "v" }, 'r', "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit")
--         map({ "n", "v" }, 'l', "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis")
--         map({ "n", "v" }, 'h', "<cmd>ChatGPTRun explain_code<CR>", "Code Explaination")
--       end
--     },
--     {
--       'brenoprata10/nvim-highlight-colors',
--       opts = {
--       },
--       config = function()
--         local plugin = require("nvim-highlight-colors")
--         plugin.setup {
--           -- render = 'virtual',
--           -- virtual_symbol_position = 'eol',
--           -- virtual_symbol = '🌑',  -- pink #AA00FF
--           -- virtual_symbol_prefix = ' ',
--         }
--         plugin.turnOn()
--         vim.keymap.set('n', '<leader>tc', plugin.toggle, { desc = "toggle highlight color" })
--       end
--     },
--     {
--       'akinsho/flutter-tools.nvim',
--       lazy = false,
--       dependencies = {
--         'nvim-lua/plenary.nvim',
--         'stevearc/dressing.nvim', -- optional for vim.ui.select
--       },
--       config = function()
--         require('flutter-tools').setup {
--           lsp = {
--             on_attach = function()
--               vim.api.nvim_set_keymap('n', '<leader>pr', ":FlutterRun<CR>", { noremap = true, silent = true })
--               vim.api.nvim_set_keymap('n', '<leader>pq', ":FlutterQuit<CR>", { noremap = true, silent = true })
--               vim.api.nvim_set_keymap('n', '<leader>pd', ":FlutterDevices<CR>", { noremap = true, silent = true })
--               vim.api.nvim_set_keymap('n', '<leader>pR', ":FlutterRestart<CR>", { noremap = true, silent = true })
--               vim.api.nvim_set_keymap('n', '<leader>pa', ":FlutterReanalyze<CR>", { noremap = true, silent = true })
--               vim.api.nvim_set_keymap('n', '<leader>po', ":FlutterOutlineToggle<CR>", { noremap = true, silent = true })
--               vim.api.nvim_set_keymap('n', '<leader>pl', ":FlutterLspRestart<CR>", { noremap = true, silent = true })
--             end,
--             capabilities = require('cmp_nvim_lsp').default_capabilities(), -- for nvim-cmp (optional)
--             init_options = {
--               closingLabels = true,                                        -- Show closing labels in code
--             },
--           },
--         }
--       end,
--     },
--     {
--       "oysandvik94/curl.nvim",
--       event = "VeryLazy",
--       dependencies = {
--         "nvim-lua/plenary.nvim",
--       },
--       config = function()
--         local curl = require("curl")
--         curl.setup({})
--         local function map(key, func, desc)
--           vim.keymap.set("n", "<leader>u" .. key, func, { desc = desc })
--         end
--         map("q", ":CurlClose<CR>", "Open curl tab")
--         map("o", curl.open_global_tab, "Open global curl tab")
--         map("cl", curl.create_scoped_collection, "Create/Open collection")
--         map("cg", curl.create_global_collection, "Create/Open global collection")
--         map("sl", curl.pick_scoped_collection, "Choose/Open scoped collection")
--         map("sg", curl.pick_scoped_collection, "Choose/Open scoped collection")
--       end,
--     },
--   },
--   {
--     ui = {
--       icons = vim.g.have_nerd_font and {} or {
--         cmd = '⌘',
--         config = '🛠',
--         event = '📅',
--         ft = '📂',
--         init = '⚙',
--         keys = '🗝',
--         plugin = '🔌',
--         runtime = '💻',
--         require = '🌙',
--         source = '📄',
--         start = '🚀',
--         task = '📌',
--         lazy = '💤 ',
--       },
--     },
--     install = { colorscheme = { "habamax" } },
--     -- checker = { enabled = true },
--     performance = {
--       cache = { enabled = true },
--       defaults = {
--         lazy = false,
--         version = false, -- always use the latest git commit
--       }
--     },
--   }
-- )

require('autocommands')
require('terminal')
require('dash')
-- the line beneath this is called `modeline`. see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
