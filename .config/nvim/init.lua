require 'options'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require 'mappings'
require 'lsp'
require('lazy').setup {
  require 'kickstart.plugins.debug', -- adds gitsigns recommend keymaps
  require 'kickstart.iron_nvim',
  -- {
  --   'pmizio/typescript-tools.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  --   opts = {
  --     expose_as_code_action = "all",
  --   },
  -- },
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
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      ---@type nvim_tree.config
      local config = {
        sort = {
          sorter = 'case_sensitive',
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      }
      require('nvim-tree').setup(config)
      vim.keymap.set('n', '<leader>v', ':NvimTreeToggle<CR>', { silent = true })
      vim.keymap.set('n', '<leader>V', function()
        require('nvim-tree.api').tree.find_file { open = true, update_root = '<bang>', focus = true }
      end, { silent = true })
    end,
  },
  require 'kickstart.nvim-highlight-colors',
  -- {
  --   'brenoprata10/nvim-highlight-colors',
  --   opts = {},
  --   config = function()
  --     local plugin = require 'nvim-highlight-colors'
  --     plugin.setup {
  --       render = 'virtual',
  --       virtual_symbol_position = 'eol',
  --       virtual_symbol = '█████████', -- pink #AA00FF ⬤ 🌑 █
  --       virtual_symbol_prefix = ' ',
  --     }
  --     plugin.turnOn()
  --     vim.keymap.set('n', '<leader>tc', plugin.toggle, { desc = 'toggle highlight color' })
  --   end,
  -- },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      -- local statusline = require 'mini.statusline'.setup()

      -- statusline.setup { use_icons = vim.g.have_nerd_font }
      -- require('mini.bracketed').setup {}
      ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end
    end,
  },

  -- {
  --   'LunarVim/bigfile.nvim',
  --   config = function()
  --     -- default config
  --     require('bigfile').setup {
  --       filesize = 1, -- size of the file in MiB, the plugin round file sizes to the closest MiB
  --       pattern = { '*' }, -- autocmd pattern or function see <### Overriding the detection of big files>
  --       features = { -- features to disable
  --         'indent_blankline',
  --         'illuminate',
  --         'lsp',
  --         'treesitter',
  --         'syntax',
  --         'matchparen',
  --         'vimopts',
  --         'filetype',
  --       },
  --     }
  --   end,
  -- },
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
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = true,
    init = function()
      vim.cmd.colorscheme 'gruvbox'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  'vifm/vifm.vim',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'kristijanhusak/vim-dadbod-completion',
  {
    'windwp/nvim-ts-autotag',
    opts = {
      aliases = {
        ['cshtml'] = 'html',
        ['razor'] = 'html',
      },
    },
  },
  -- {
  --   'zbirenbaum/copilot-cmp',
  --   config = function()
  --     require('copilot_cmp').setup()
  --   end,
  -- },
  -- {
  --   'github/copilot.vim',
  --   config = function()
  --     -- require('copilot').setup {
  --     --   suggestion = { enabled = false },
  --     --   panel = { enabled = false },
  --     -- }
  --     vim.cmd ':Copilot disable'
  --     vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-suggest)')
  --     vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  --       expr = true,
  --       replace_keycodes = false,
  --     })
  --   end,
  -- },
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    -- event = 'VeryLazy', -- or a specific command like 'Telescope'
    version = '*',
    -- branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      -- { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local telescope = require 'telescope'
      local themes = require 'telescope.themes'
      local builtin = require 'telescope.builtin'

      telescope.setup {
        defaults = {
          file_ignore_patterns = {
            -- 'lib',
            'bin',
            'obj',
            '.git',
            'node_modules',
            '__pycache__',
            '%.png',
            '%.jpg',
            '%.jpg',
            'Migrations',
            'venv',
          },
        },
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

          hidden = false,
        }
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
          width = 95,
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
    'yetone/avante.nvim',
    build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- Never set this value to "*"! Never!
    dependencies = {
      {
        'ravitemer/mcphub.nvim',
        config = function()
          require('mcphub').setup {
            extensions = {
              avante = {
                make_slash_commands = true,
              },
            },
          }
        end,
      },
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
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
          file_types = { 'markdown', 'Avante' },
          latex = { enabled = false },
          -- anti_conceal = {
          --   enabled = false,
          -- },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
    -- opts = {},
    config = function()
      require('avante').setup {
        acp_providers = {
          ['gemini-cli'] = {
            command = 'gemini',
            args = { '--experimental-acp' },
            env = {
              NODE_NO_WARNINGS = '1',
              GEMINI_API_KEY = os.getenv 'GEMINI_API_KEY',
            },
          },
          ['goose'] = {
            command = 'goose',
            args = { 'acp' },
          },

          ['opencode'] = {
            command = 'opencode',
            args = { 'acp' },
          },
        },
        behaviour = {
          enable_fastapply = true, -- Enable Fast Apply feature
        },
        instructions_file = 'AGENTS.md',
        selection = {
          enabled = false,
          hint_display = 'delayed',
        },
        windows = {
          ---@type "right" | "left" | "top" | "bottom"
          position = 'right', -- the position of the sidebar
          wrap = true, -- similar to vim.o.wrap
          width = 40, -- default % based on available width
          sidebar_header = {
            enabled = true, -- true, false to enable/disable the header
            align = 'center', -- left, center, right for title
            rounded = true,
          },
          input = {
            prefix = '> ',
            height = 20, -- Height of the input window in vertical layout
          },
          ask = {
            floating = false, -- Open the 'AvanteAsk' prompt in a floating window
            start_insert = false, -- Start insert mode when opening the ask window
            border = 'rounded',
          },
        },
        -- auto_suggestions_provider = 'ollama',

        -- provider = 'ollama',
        -- provider = 'openrouter',
        -- provider = 'goose',
        provider = 'openrouter',
        providers = {
          openai = {
            endpoint = 'https://api.openai.com/v1',
            model = 'gpt-5.4',
            timeout = 30000,
            -- extra_request_body = {
            --   temperature = 0.1,
            -- },
          },

          deepseek = {
            __inherited_from = 'openai',
            api_key_name = 'DEEPSEEK_API_KEY',
            endpoint = 'https://api.deepseek.com',
            model = 'deepseek-coder',
          },

          openrouter = {
            __inherited_from = 'openai',
            endpoint = 'https://openrouter.ai/api/v1',
            api_key_name = 'OPENROUTER_API_KEY',
            -- model = 'deepseek/deepseek-r1',
            -- model = 'deepseek/deepseek-v3.2',
            -- model = 'openrouter/auto',
            model = 'openai/gpt-oss-120b:free',
            -- model = 'nvidia/nemotron-3-super-120b-a12b:free',
          },
          ollama = {
            endpoint = 'http://127.0.0.1:11434',
            -- model = 'deepseek-coder-v2',
            -- model = 'qwen3.5:397b-cloud',
            -- model = 'qwen2.5-coder',
            -- model = 'qwen3.5:2b',
            -- model = 'gpt-oss:20b-cloud',
            -- model = 'gemma4:31b-cloud',
            -- model = 'qwen3-coder-next:cloud',
            keep_alive = '30m',
            -- extra_request_body = {
            --   options = {
            --     temperature = 0.75,
            --     num_ctx = 20480,
            --   },
            -- },
          },
        },
        system_prompt = function()
          local hub = require('mcphub').get_hub_instance()
          return hub and hub:get_active_servers_prompt() or ''
        end,
        custom_tools = function()
          return {
            require('mcphub.extensions.avante').mcp_tool(),
          }
        end,
      }
      -- vim.keymap.set({ 'n', 'i', 'v' }, '<C-h>', '<cmd>AvanteToggle<CR>', { desc = 'Toggle Avante' })

      vim.keymap.set('n', 'ZQ', function()
        local ft = vim.bo.filetype:lower()

        if ft:match '^avante' then
          vim.cmd 'AvanteToggle'
        else
          vim.cmd 'q!'
        end
      end, { desc = 'Smart quit (Avante ft or force quit)' })
    end,
  },
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', ':G<CR>', { desc = 'Git status' })
      vim.keymap.set('n', '<leader>gc', ':G commit<CR>', { desc = 'Git commit' })
      vim.keymap.set('n', '<leader>gaf', ':G add %<CR>', { desc = 'Git add file' })
      vim.keymap.set('n', '<leader>gad', ":G add <C-r>=expand('%:h')<CR>", { desc = 'Git add directory' })
      vim.keymap.set('n', '<leader>gac', ':G commit %<CR>', { desc = 'Git commit file' })
      vim.keymap.set('n', '<leader>gvd', ':Gvdiffsplit<CR>', { desc = 'Git vertical diff split' })
      vim.keymap.set('n', '<leader>gp', ':G push<CR>', { desc = 'Git vertical diff split' })
    end,
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead', 'BufNewFile' }, -- Load only when reading or creating a file
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
  },

  -- { -- Highlight, edit, and navigate code
  --   'nvim-treesitter/nvim-treesitter',
  --   branch = 'master',
  --   build = ':TSUpdate',
  --   opts = {
  --     ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
  --     auto_install = true,
  --     highlight = {
  --       enable = true,
  --       additional_vim_regex_highlighting = { 'ruby' },
  --       disable = function(lang, buf)
  --         local max_filesize = 1024 * 1024 -- 1 MB
  --         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  --         if ok and stats and stats.size > max_filesize then
  --           return true
  --         end
  --       end,
  --     },
  --   },
  --   config = function(_, opts)
  --     require('nvim-treesitter.install').prefer_git = true
  --     require('nvim-treesitter.configs').setup(opts)
  --   end,
  -- },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'Hoffs/omnisharp-extended-lsp.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },

      'mfussenegger/nvim-jdtls',
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        -- html = {},
        -- clangd = {},
        -- gopls = {},
        -- rust_analyzer = {},
        omnisharp = {
          enable_roslyn_analyzers = false,
          enable_ms_build_load_projects_on_demand = false,
          organize_imports_on_format = false,
        },

        -- -- Python LSPs
        -- ruff = {},
        -- basedpyright ={},

        -- Python formatter/linter
        -- black = {},

        -- Lua language server
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT', -- Neovim uses LuaJIT
              },
              diagnostics = {
                globals = { 'vim' }, -- Recognize `vim` as a global
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true), -- Add Neovim runtime files
                checkThirdParty = false, -- Avoid annoying prompts
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Lua formatter,
        'lemminx',
        'json-lsp',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            vim.lsp.config(server_name, server)
          end,
        },
      }

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = {
              -- Use LuaJIT in Neovim
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Tell the LSP that `vim` is a global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        init_options = {
          preferences = {
            importModuleSpecifierPreference = 'relative',
            importModuleSpecifierEnding = 'minimal',
          },
        },
      })

      -- vim.lsp.config('omnisharp', {
      --   enable_roslyn_analyzers = false,
      --   enable_ms_build_load_projects_on_demand = false,
      --   organize_imports_on_format = false,
      -- })

      vim.lsp.config('pyright', {
        capabilities = capabilities,
        venv = '.venv',
        analysis = {
          -- venvPath = '/home/a/venv',
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
        root_markers = { '.git', '.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' },
      })
    end,
  },
  -- {
  --   'Saghen/blink.cmp',
  --   version = '1.*', -- 👈 important
  --   event = 'InsertEnter',
  --   dependencies = {
  --     'rafamadriz/friendly-snippets', -- 👈 REQUIRED (actual snippets)
  --    'xabikos/vscode-react',
  --    -- { 'L3MON4D3/LuaSnip', version = 'v2.*' },
  --     -- 'Kaiser-Yang/blink-cmp-avante',
  --     'hrsh7th/vim-vsnip',
  --     -- 'https://codeberg.org/FelipeLema/bink-cmp-vsnip.git',
  --     -- 'echasnovski/mini.snippets',
  --   },
  --
  --   opts = {
  --     snippets = { preset = 'vsnip' },
  --     keymap = {
  --       preset = 'default',
  --       -- Trigger
  --       ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
  --       -- Navigate
  --       ['<C-n>'] = { 'select_next' },
  --       ['<C-p>'] = { 'select_prev' },
  --       ['<S-Tab>'] = { 'select_prev', 'fallback' },
  --
  --       ['<C-u>'] = { 'scroll_signature_up', 'fallback' },
  --       ['<C-d>'] = { 'scroll_signature_down', 'fallback' },
  --
  --       -- default in all keymap presets
  --       -- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
  --       -- Accept (like VSCode Enter)
  --       ['<CR>'] = { 'accept', 'fallback' },
  --     },
  --     signature = { enabled = true },
  --     completion = {
  --       documentation = { auto_show = true },
  --       list = {
  --         selection = {
  --           preselect = false,
  --           auto_insert = true,
  --         },
  --       },
  --       ghost_text = {
  --         enabled = false,
  --       },
  --     },
  --     sources = {
  --       default = { 'lsp', 'path', 'snippets', 'buffer' },
  --       per_filetype = {
  --         sql = { 'snippets', 'dadbod', 'buffer' },
  --       },
  --       providers = {
  --         dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
  --         avante = {
  --           module = 'blink-cmp-avante',
  --           name = 'Avante',
  --         },
  --       },
  --     },
  --   },
  -- },

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
              require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/lua/snippets/' }
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'onsails/lspkind.nvim',
      'lukas-reineke/cmp-under-comparator',
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
        -- window = {
        --   completion = cmp.config.window.bordered(),
        --   documentation = cmp.config.window.bordered(),
        -- },
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
          -- { name = 'copilot', group_index = 2 },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'buffer' },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- formatting = {
        --   format = require('nvim-highlight-colors').format,
        -- },
      }
    end,
  },
  -- {
  --   'nickjvandyke/opencode.nvim',
  --   version = '*',
  --   dependencies = {
  --     {
  --       'folke/snacks.nvim',
  --       optional = false,
  --       opts = {
  --         input = {},
  --         picker = {
  --           actions = {
  --             opencode_send = function(...)
  --               return require('opencode').snacks_picker_send(...)
  --             end,
  --           },
  --           win = {
  --             input = {
  --               keys = {
  --                 ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
  --               },
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  --
  --   config = function()
  --     vim.g.opencode_opts = {
  --       -- keep minimal; extend later if needed
  --     }
  --
  --     vim.o.autoread = true
  --     local function map(modes, key, prompt, desc)
  --       vim.keymap.set(modes, '<leader>c' .. key, function()
  --         require('opencode').ask(prompt, { submit = true })
  --       end, { desc = 'AI: ' .. desc })
  --     end
  --
  --     vim.keymap.set({ 'n', 'v' }, '<leader>cc', function()
  --       require('opencode').toggle()
  --     end, { desc = 'AI: toogle opencode ' })
  --
  --     map({ 'n', 'v' }, 'e', '@this: Edit this according to the instruction I will provide.', 'Edit with instruction')
  --     map({ 'n', 'v' }, 'g', '@this: Fix grammar and improve clarity.', 'Grammar Correction')
  --     map({ 'n', 'v' }, 't', '@this: Translate this to English.', 'Translate')
  --     map({ 'n', 'v' }, 'd', '@this: Write a proper docstring for this code.', 'Docstring')
  --     map({ 'n', 'v' }, 'o', '@this: Optimize this code for performance and readability without changing behavior.', 'Optimize Code')
  --     map({ 'n', 'v' }, 'f', '@this: Fix bugs. Return only the corrected code.', 'Fix Bugs')
  --     map({ 'n', 'v' }, 'r', '@this: Improve comments in roxygen style.', 'Roxygen Edit')
  --     map({ 'n', 'v' }, 'l', '@this: Analyze code readability and suggest improvements.', 'Code Readability')
  --     map({ 'n', 'v' }, 'h', '@this: Explain this code step by step.', 'Explain Code')
  --     ------------------------------------------------------------------
  --     -- Core opencode keymaps (recommended)
  --     ------------------------------------------------------------------
  --     -- vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
  --     --   require('opencode').ask('@this: ', { submit = true })
  --     -- end, { desc = 'Ask AI…' })
  --     --
  --     -- vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
  --     --   require('opencode').select()
  --     -- end, { desc = 'AI actions…' })
  --     --
  --     -- vim.keymap.set({ 'n', 't' }, '<C-.>', function()
  --     --   require('opencode').toggle()
  --     -- end, { desc = 'Toggle AI' })
  --
  --     ------------------------------------------------------------------
  --     -- Operator support (VERY powerful)
  --     ------------------------------------------------------------------
  --     -- vim.keymap.set({ 'n', 'x' }, 'go', function()
  --     --   return require('opencode').operator '@this '
  --     -- end, { expr = true, desc = 'Send motion to AI' })
  --     --
  --     -- vim.keymap.set('n', 'goo', function()
  --     --   return require('opencode').operator '@this ' .. '_'
  --     -- end, { expr = true, desc = 'Send line to AI' })
  --
  --     ------------------------------------------------------------------
  --     -- Scrolling inside AI window
  --     ------------------------------------------------------------------
  --     -- vim.keymap.set('n', '<S-C-u>', function()
  --     --   require('opencode').command 'session.half.page.up'
  --     -- end, { desc = 'Scroll AI up' })
  --     --
  --     -- vim.keymap.set('n', '<S-C-d>', function()
  --     --   require('opencode').command 'session.half.page.down'
  --     -- end, { desc = 'Scroll AI down' })
  --
  --     ------------------------------------------------------------------
  --     -- Fix conflicts with default Vim increment/decrement
  --     ------------------------------------------------------------------
  --     -- vim.keymap.set('n', '+', '<C-a>', { noremap = true, desc = 'Increment' })
  --     -- vim.keymap.set('n', '-', '<C-x>', { noremap = true, desc = 'Decrement' })
  --   end,
  -- },
  -- {
  --   'jackMort/ChatGPT.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'nvim-lua/plenary.nvim',
  --     {
  --       'folke/trouble.nvim',
  --       config = true,
  --     },
  --     'nvim-telescope/telescope.nvim',
  --   },
  --   config = function()
  --     require('chatgpt').setup {
  --       -- openai_params = {
  --       --   model = 'gpt-4-1106-preview',
  --       --   frequency_penalty = 0,
  --       --   presence_penalty = 0,
  --       --   max_completion_tokens = 4095,
  --       --   temperature = 0.2,
  --       --   top_p = 0.1,
  --       --   n = 1,
  --       -- },
  --     }
  --     local map = function(modes, key, cmd, descrp)
  --       vim.keymap.set(modes, '<leader>c' .. key, cmd, { desc = 'GPT: ' .. descrp })
  --     end
  --
  --     map({ 'n', 'v' }, 'c', '<cmd>ChatGPT<CR>', 'ChatGPT')
  --     map({ 'n', 'v' }, 'e', '<cmd>ChatGPTEditWithInstruction<CR>', 'Edit with instruction')
  --     map({ 'n', 'v' }, 'g', '<cmd>ChatGPTRun grammar_correction<CR>', 'Grammar Correction')
  --     map({ 'n', 'v' }, 't', '<cmd>ChatGPTRun translate<CR>', 'Translate')
  --     map({ 'n', 'v' }, 'd', '<cmd>ChatGPTRun docstring<CR>', 'Docstring')
  --     map({ 'n', 'v' }, 'o', '<cmd>ChatGPTRun optimize_code<CR>', 'Optimize Code')
  --     map({ 'n', 'v' }, 'f', '<cmd>ChatGPTRun fix_bugs<CR>', 'Fix Bugs')
  --     map({ 'n', 'v' }, 'r', '<cmd>ChatGPTRun roxygen_edit<CR>', 'Roxygen Edit')
  --     map({ 'n', 'v' }, 'l', '<cmd>ChatGPTRun code_readability_analysis<CR>', 'Code Readability Analysis')
  --     map({ 'n', 'v' }, 'h', '<cmd>ChatGPTRun explain_code<CR>', 'Code Explaination')
  --   end,
  -- },
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
            vim.api.nvim_set_keymap('n', '<leader>pr', ':FlutterRun<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pe', ':FlutterEmulators<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pq', ':FlutterQuit<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pd', ':FlutterDevices<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pR', ':FlutterRestart<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pa', ':FlutterReanalyze<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>po', ':FlutterOutlineToggle<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pl', ':FlutterLspRestart<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>pll', ':FlutterLogToggle<CR>', { noremap = true, silent = true })
          end,
          -- capabilities = require('blink.cmp').get_lsp_capabilities(),
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
          init_options = {
            closingLabels = true, -- Show closing labels in code
          },
        },
        dev_log = {
          enabled = true, -- don't show logs automatically
        },
      }
    end,
  },
  { 'nvim-tree/nvim-web-devicons', opts = {} },
  -- {
  --   'abecodes/tabout.nvim',
  --   lazy = false,
  --   config = function()
  --     require('tabout').setup {
  --       tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
  --       backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
  --       act_as_tab = true, -- shift content if tab out is not possible
  --       act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
  --       default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
  --       default_shift_tab = '<C-d>', -- reverse shift default action,
  --       enable_backwards = true, -- well ...
  --       completion = false, -- if the tabkey is used in a completion pum
  --       tabouts = {
  --         { open = "'", close = "'" },
  --         { open = '"', close = '"' },
  --         { open = '`', close = '`' },
  --         { open = '(', close = ')' },
  --         { open = '[', close = ']' },
  --         { open = '{', close = '}' },
  --       },
  --       ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
  --       exclude = {}, -- tabout will ignore these filetypes
  --     }
  --   end,
  --   dependencies = { -- These are optional
  --     'nvim-treesitter/nvim-treesitter',
  --     'L3MON4D3/LuaSnip',
  --     'hrsh7th/nvim-cmp',
  --   },
  --   opt = true, -- Set this to true if the plugin is optional
  --   event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
  --   priority = 1000,
  -- },
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   opts = {},
  -- },
  -- {
  --   'L3MON4D3/LuaSnip',
  --   keys = function()
  --     -- Disable default tab keybinding in LuaSnip
  --     return {}
  --   end,
  -- },
}

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

require 'autocommands'
require 'terminal'
require 'dash'
-- require('auto-session')
-- the line beneath this is called `modeline`. see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
