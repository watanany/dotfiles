local utils = require("utils")

return {
  -- Configurations for Nvim LSP
  { "neovim/nvim-lspconfig" },

  -- カラースキーム
  {
    "w0ng/vim-hybrid",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[
        set background=dark
        colorscheme hybrid
      ]]
    end,
    enabled = false,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
    enabled = true,
  },

  -- Neovim用のLuaの関数集
  { "nvim-lua/plenary.nvim" },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- FIXME:
      -- すでにパスは入っているがcheckhealthでエラーになっている
      -- treesitter側のバグの可能性あり
      vim.opt.runtimepath:append(
        vim.fn.stdpath("data") .. "/site/"
      )

      local treesitter = require("nvim-treesitter")
      treesitter.setup()
      treesitter.install {
        "lua", "bash", "regex", "python", "sql",
        "markdown", "javascript", "rust", "haskell",
      }
    end,
  },

  -- カーソル移動加速プラグイン
  { "rainbowhxch/accelerated-jk.nvim" },

  -- f + 一文字で検索
  { "rhysd/clever-f.vim", enabled = true },
  { "ggandor/lightspeed.nvim", enabled = false },

  ----------------------------------------------------------------------
  -- セッション管理
  ----------------------------------------------------------------------
  {
    "rmagatti/auto-session",
    lazy = false,

    config = function()
      -- cf. <https://github.com/rmagatti/auto-session?tab=readme-ov-file#recommended-sessionoptions-config>
      -- NOTE: このプラグインのsetup前に設定しないと警告が出る
      vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

      require("auto-session").setup {
        auto_restore_last_session = true,
      }
    end,

    enabled = false,
  },

  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("session_manager").setup {}
    end,
    enabled = true,
  },

  ----------------------------------------------------------------------
  -- タブ制御
  ----------------------------------------------------------------------
  {
    "crispgm/nvim-tabline",
    dependencies = {
      { "nvim-lualine/lualine.nvim", lazy = true },
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    config = function()
      require("tabline").setup {}
    end,
    enabled = false,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        mode = "tabs",
        numbers = "ordinal",

        name_formatter = function(buf)
          if vim.uv.fs_stat(buf.path) then
            local path = vim.api.nvim_buf_get_name(buf.bufnr)
            local root = vim.fs.root(path, { ".git" })
            return root and vim.fs.basename(root) or vim.fs.basename(path)
          else
            return buf.name
          end
        end,

        show_buffer_icons = true,
        sort_by = "tabs",
      }
    },
    enabled = true,
  },

  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",     -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      icons = {
        buffer_index = true,
      },
    },
    enabled = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_b = { "diff", "diagnostics" },
        lualine_c = { { "filename", path = 3 } },
      },
    },
    enabled = true,
  },

  ----------------------------------------------------------------------
  -- ファイラー
  ----------------------------------------------------------------------
  {
    "lambdalisue/vim-fern",
    keys = {
      {
        "<Leader>ft",
        ":Fern . -drawer -width=50<CR>",
        desc = "ファイルツリーを開く",
      },
    },
  },

  -- fzf本体(CLI)
  {
    "junegunn/fzf",
    build = ":call fzf#install()",
    enabled = false,
  },

  -- vim用のfzfプラグイン
  {
    "junegunn/fzf.vim",
    init = function()
      -- fzfのコマンドのプレフィックスを設定(e.g. :Files -> :FzfFiles)
      vim.g.fzf_command_prefix = "Fzf"
    end,
    enabled = false,
  },

  ----------------------------------------------------------------------
  -- ファジーファインダー
  ----------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- Telescopeの設定を行う
      local telescope = require("telescope")
      local telescope_actions = require("telescope.actions")

      telescope.setup {
        extensions = {
          project = {
            base_dirs = {
              { path = "~/dotfiles", max_depth = 1 },
              { path = "~/sanctum/org", max_depth = 1 },
              { path = "~/sanctum/projects", max_depth = 2 },
              { path = "~/sanctum/goals", max_depth = 2 },
            },
            order_by = "asc",
            hidden_files = true,
            cd_scope = { "tab" },
          },
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          },
        },
        defaults = {
          mappings = {
            n = {
              ["<C-;>"] = telescope_actions.close,
              ["<C-q>"] = telescope_actions.close,
            },
            i = {
              -- 最初のESCでTelescopeを閉じる
              -- cf. <https://www.reddit.com/r/neovim/comments/pzxw8h/telescope_quit_on_first_single_esc/>
              ["<Esc>"] = telescope_actions.close,

              ["<C-h>"] = "which_key",
              ["<C-;>"] = telescope_actions.close,
              ["<C-q>"] = telescope_actions.close,

              ["<C-f>"] = function()
                local keys = vim.api.nvim_replace_termcodes("<Right>", true, false, true)
                vim.fn.feedkeys(keys, "n")
              end,

              ["<C-b>"] = function()
                local keys = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
                vim.fn.feedkeys(keys, "n")
              end,

              ["<C-k>"] = kill_line,
            },
          },
        },
      }
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-telescope/telescope-project.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      {
        "<Leader>pp",
        function() require("telescope").extensions.project.project() end,
        desc = "プロジェクトを開く",
      },
    },
    config = function()
      require("telescope").load_extension("project")
    end,
  },

  {
    "smartpde/telescope-recent-files",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("recent_files")
    end,
  },

  {
    "nvim-telescope/telescope-frecency.nvim",
    keys = {
      {
        "<Leader>fr",
        "<cmd>Telescope frecency<CR>",
        desc = "最近開いたファイルで検索する",
      },
      {
        "<Leader>fR",
        "<cmd>Telescope frecency workspace=CWD<CR>",
        desc = "最近開いたファイルで検索する(workspace=CWD)",
      },
    },
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern" },
        patterns = { ".git" },
        show_hidden = true,
        scope_chdir = "tab",
      }
      require("telescope").load_extension("projects")
    end,
    enabled = false,
  },

  {
    "notjedi/nvim-rooter.lua",
    lazy = false,
    config = function()
      require("nvim-rooter").setup {}
    end,
    enabled = false,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    -- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  ----------------------------------------------------------------------
  -- ターミナル
  ----------------------------------------------------------------------
  -- ターミナルをトグルする機能を追加
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup {
        size = 20,
        open_mapping = "<C-\\>",
      }
    end,
    enabled = false,
  },

  {
    "watanany/tabtoggleterm.nvim",
    enabled = false,
  },

  -- ターミナル内でneovimを開けるようにする
  {
    "samjwill/nvim-unception",
    init = function()
      vim.g.unception_open_buffer_in_new_tab = true
    end,
  },

  ----------------------------------------------------------------------
  -- 補完プラグイン
  ----------------------------------------------------------------------
  -- スニペット
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },

  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")

      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-q>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources(
          {
            { name = "lazydev" },
          },
          {
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "copilot" },
            { name = "command" },
            { name = "calc" },
            { name = "nvim_lua" },
            { name = "render-markdown" },
          },
          {
            { name = "buffer" },
          }
        ),
        formatting = {
          format = require("lspkind").cmp_format {
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
          },
        },
      }
    end,
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = { "hrsh7th/nvim-cmp" },
  },

  {
    "hrsh7th/cmp-buffer",
    dependencies = { "hrsh7th/nvim-cmp" },
  },

  {
    "hrsh7th/cmp-path",
    dependencies = { "hrsh7th/nvim-cmp" },
  },

  {
    "hrsh7th/cmp-cmdline",
    dependencies = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-buffer" },
  },

  {
    "hrsh7th/cmp-nvim-lua",
    dependencies = { "hrsh7th/nvim-cmp" },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        -- suggestion = { enabled = false },
        -- panel = { enabled = false },
      }
    end,
    enabled = false,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- vscodeのようなピクトグラムをneovimのLSP機能に追加する
  {
    "onsails/lspkind.nvim",
  },

  -- kocmd
  {
    "watanany/kocmd.nvim",
    keys = {
      {
        "<Leader>ot",
        function()
          require("kocmd").toggle("shell")
        end,
        desc = "Toggle shell",
      },
      {
        "<Leader>og",
        function()
          require("kocmd").toggle("lazygit")
        end,
        desc = "Toggle lazygit",
      },
      {
        "<Leader>od",
        function()
          require("kocmd").toggle("lazydocker")
        end,
        desc = "Toggle lazydocker",
      },
      {
        "<Leader>oc",
        function()
          require("kocmd").toggle("claude")
        end,
        desc = "Toggle Claude Code",
      },
      {
        "<Leader>ox",
        function()
          require("kocmd").toggle("codex")
        end,
        desc = "Toggle OpenAI Codex CLI",
      },
    },
    opts = {
      commands = {
        shell = {
          cmd = vim.o.shell,
          position = "bottom",
          size = 20,
        },
        lazygit = {
          cmd = "lazygit",
          position = "float",
          size = { width = 0.95, height = 0.95 },
        },
        lazydocker = {
          cmd = "lazydocker",
          position = "float",
          size = { width = 0.95, height = 0.95 },
        },
        claude = {
          cmd = "claude",
          position = "left",
          size = 60,
        },
        codex = {
          cmd = "codex",
          position = "left",
          size = 60,
        },
      },
    },
    dev = true,
  },

  -- Claude Code
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<Leader>a", nil, desc = "AI/Claude Code" },
      { "<Leader>ac", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude" },
      { "<Leader>af", "<cmd>ClaudeCodeFocus<CR>", desc = "Focus Claude" },
      { "<Leader>ar", "<cmd>ClaudeCode --resume<CR>", desc = "Resume Claude" },
      { "<Leader>aC", "<cmd>ClaudeCode --continue<CR>", desc = "Continue Claude" },
      { "<Leader>ab", "<cmd>ClaudeCodeAdd %<CR>", desc = "Add current buffer" },
      { "<Leader>as", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "Send to Claude" },
      {
        "<Leader>as",
        "<cmd>ClaudeCodeTreeAdd<CR>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<Leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
      { "<Leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "Deny diff" },
    },
    opts = {
      terminal = {
        -- snacks_win_opts = {
        --   position = "float",
        --   width = 0.60,
        --   height = 0.60,
        --   border = "double",
        --   backdrop = 80,
        -- },
        snacks_win_opts = {
          position = "left",
          width = 0.25,
          height = 0.25,
          border = "single",
        },
      },
    },
    enabled = false,
  },

  -- jsonls/yamllsで使用するスキーマ用のプラグイン
  {
    "b0o/schemastore.nvim",
  },

  ----------------------------------------------------------------------
  -- syntax highlight
  ----------------------------------------------------------------------
  -- TODOコメントのハイライト
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        keyword = "fg",
        after = "",
        pattern = "(KEYWORDS):",
      },
    },
  },

  -- インデントガイドラインの追加
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",

    ---@module "ibl"
    ---@type ibl.config
    opts = {
      scope = { enabled = false },
    },
  },

  -- CSVを見やすく色付け
  { "mechatroner/rainbow_csv" },

  {
    "mrcjkb/haskell-tools.nvim",
    version = "^4",
    lazy = false,
  },

  { "sdiehl/vim-cabalfmt" },

  { "purescript-contrib/purescript-vim" },

  { "hylang/vim-hy" },

  {
    "chrismaher/vim-lookml",
    enabled = false,
  },

  { "posva/vim-vue" },

  -- 色コードを彩色する
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {
        "*",
      }
    end,
  },

  -- F#
  { "adelarsq/neofsharp.vim" },

  -- Lean 4
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    ---@type lean.Config
    opts = { -- see below for full configuration options
      mappings = true,
    }
  },

  -- flix
  {
    "flix/nvim",
    opts = {},
  },

  ----------------------------------------------------------------------
  -- markdown
  ----------------------------------------------------------------------
  -- nvim内でmarkdownをプレビューする(:Glow)
  {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup {}
    end,
  },

  -- ブラウザでmarkdownをプレビューする(:MarkdownPreview & :MarkdownPreviewStop)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,

    -- FIXME: <https://github.com/iamcco/markdown-preview.nvim/issues/690>
    enabled = false,
  },

  -- markdown用のマッピングを追加する
  {
    "SidOfc/mkdx",
    init = function()
      vim.g.mkdx = {
        settings = {
          highlight = { enabled = true },
          enter = { shift = true },
          links = { external = { enabled = true } },
          toc = { text = "Table of Contents", update_on_write = true },
          fold = { enabled = false },
        },
      }
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {},
  },

  -- markdownのテーブル作成とフォーマット(:TableModeToggleで有効化する)
  { "dhruvasagar/vim-table-mode" },

  -- org
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/sanctum/org/**/*",
        org_default_notes_file = "~/sanctum/org/refile.org",
      })

      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require("nvim-treesitter.configs").setup({
      --   ensure_installed = "all",
      --   ignore_install = { "org" },
      -- })
    end,
    enabled = false,
  },

  -- luarocks
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    enabled = false,
  },

  ----------------------------------------------------------------------
  -- その他
  ----------------------------------------------------------------------
  -- 対応する文字を閉じる
  {
    "m4xshen/autoclose.nvim",
    config = function()
      local autoclose = require("autoclose")
      autoclose.setup {
        keys = {
          -- ['"'] = { escape = true, close = false, pair = '""' },
          -- ["'"] = { escape = true, close = false, pair = "''" },
          -- ["`"] = { escape = true, close = false, pair = "``" },
        },
        options = {
          disable_when_touch = true,
          touch_regex = "[%w(%[{ぁ-んァ-ヶー一-龯]"
        },
      }
    end,
    enabled = false,
  },

  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {},
    enabled = false,
  },

  -- endを自動で補完する
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- treesitterでtextobjectを設定できるようにする
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- surroundを追加
  {
    "kylechui/nvim-surround",
    version = "*", -- for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  -- 通知表示機能
  {
    "rcarriga/nvim-notify",
    init = function()
      vim.o.termguicolors = true
    end,
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- messages, cmdline, popupmenuのUIを改善
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
    enabled = true,
  },

  -- :messagesをバッファとして表示(Bmessages)
  {
    "ariel-frischer/bmessages.nvim",
    event = "CmdlineEnter",
    opts = {}
  },

  -- 利用可能なキーマップを表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- 外部ツールのインストール
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup {}
    end,
    enabled = false,
  },

  -- windowを消さないbdコマンド(:Bdeleteと:Bwipeoutを追加)
  { "famiu/bufdelete.nvim" },

  --
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        sources = {
          -- null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.completion.spell,
        },
      }
    end,
    enabled = true,
  },

  -- Lua
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- nvim-cmpと競合しそう
  -- { -- optional blink completion source for require statements and module annotations
  --   "saghen/blink.cmp",
  --   opts = {
  --     sources = {
  --       -- add lazydev to your completion providers
  --       default = { "lazydev", "lsp", "path", "snippets", "buffer" },
  --       providers = {
  --         lazydev = {
  --           name = "LazyDev",
  --           module = "lazydev.integrations.blink",
  --           -- make lazydev completions top priority (see `:h blink.cmp`)
  --           score_offset = 100,
  --         },
  --       },
  --     },
  --   },
  -- },

  -- git-blame
  {
    "f-person/git-blame.nvim",

    -- load the plugin at startup
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin will only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    event = "VeryLazy",

    opts = {
      enabled = false,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%Y-%m-%d %H:%M:%S",
      virtual_text_column = 1,
    },
  },

  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup {}
    end,
    opts = {},
    enabled = false,
  },

  -- Lua Lisp
  {
    "Olical/nfnl",
    ft = "fennel",
  },

  {
    "renerocksai/telekasten.nvim",
    dependencies = {"nvim-telescope/telescope.nvim"},
    config = function()
      local telekasten = require("telekasten")
      telekasten.setup {
        home = vim.fn.expand("~/sanctum/org/zk")
      }
    end,
    enabled = true,
  },

  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
        processor = "magick_cli",
    },
    enabled = true,
  },
}
