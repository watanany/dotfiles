return {
  -- Configurations for Nvim LSP
  { "neovim/nvim-lspconfig" },

  -- カラースキーム
  { "w0ng/vim-hybrid" },

  -- Neovim用のLuaの関数集
  { "nvim-lua/plenary.nvim" },

  -- tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  },

  -- カーソル移動加速プラグイン
  { "rainbowhxch/accelerated-jk.nvim" },

  -- f + 一文字で検索
  { "rhysd/clever-f.vim" },

  ----------------------------------------------------------------------
  -- セッション管理
  ----------------------------------------------------------------------
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/" },
      }
    end,
  },

  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("session_manager").setup {}
    end,
  },

  ----------------------------------------------------------------------
  -- タブ制御
  ----------------------------------------------------------------------
  {
    "crispgm/nvim-tabline",
    dependencies = {
      { "hoob3rt/lualine.nvim", lazy = true },
      { "kyazdani42/nvim-web-devicons", lazy = true },
    },
    config = function()
      require("tabline").setup {}
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
    enable = false,
  },

  ----------------------------------------------------------------------
  -- ファイラー
  ----------------------------------------------------------------------
  { "lambdalisue/fern.vim" },

  -- fzf本体(CLI)
  {
    "junegunn/fzf",
    build = ":call fzf#install()",
    enable = false,
  },

  -- vim用のfzfプラグイン
  {
    "junegunn/fzf.vim",
    init = function()
      -- fzfのコマンドのプレフィックスを設定(e.g. :Files -> :FzfFiles)
      vim.g.fzf_command_prefix = "Fzf"
    end,
    enable = false,
  },

  ----------------------------------------------------------------------
  -- ファジーファインダー
  ----------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
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
    end
  },

  {
    "watanany/tabtoggleterm.nvim",
    config = function()
      require("tabtoggleterm").setup {
        size = 20,
      }
    end,
  },

  -- ターミナル内でneovimを開けるようにする
  {
    "samjwill/nvim-unception",
    init = function()
      vim.g.unception_open_buffer_in_new_tab = true
    end,
  },

  ----------------------------------------------------------------------
  -- 補完プラグライン
  ----------------------------------------------------------------------
  -- スニペット
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },

  { "hrsh7th/nvim-cmp" },

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
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup {}
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    -- after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  ----------------------------------------------------------------------
  -- syntax highlight
  ----------------------------------------------------------------------
  -- TODOコメントのハイライト
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup {
        highlight = {
          keyword = "fg",
          after = "",
          pattern = "(KEYWORDS):",
        },
      }
    end,
  },

  -- インデントガイドラインの追加
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("ibl").setup {
        scope = { enabled = false },
      }
    end,
  },

  -- CSVを見やすく色付け
  { "mechatroner/rainbow_csv" },

  {
    "mrcjkb/haskell-tools.nvim",
    version = "^3",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  },

  {
    "purescript-contrib/purescript-vim"
  },

  { "hylang/vim-hy" },

  {
    "chrismaher/vim-lookml",
    enable = false,
  },

  { "posva/vim-vue" },

  ----------------------------------------------------------------------
  -- markdown
  ----------------------------------------------------------------------
  {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup {}
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    "SidOfc/mkdx",
    init = function()
      vim.g.mkdx = {
        settings = {
          highlight = { enable = true },
          enter = { shift = true },
          links = { external = { enable = true } },
          toc = { text = "Table of Contents", update_on_write = true },
          fold = { enable = false },
        },
      }
    end,
  },

  { "dhruvasagar/vim-table-mode" },

  -- markdown内のコードブロック内をシンタックスハイライト
  {
    "yaocccc/nvim-hl-mdcodeblock.lua",
    -- after = "nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("hl-mdcodeblock").setup {}
    end,
  },

  ----------------------------------------------------------------------
  -- org-mode
  ----------------------------------------------------------------------
  -- {
  --   "nvim-orgmode/orgmode",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     local orgmode = require("orgmode")
  --     orgmode.setup {
  --       org_agenda_files = { "~/sanctum/org/**/*.org" },
  --     }
  --   end,
  --   enable = false,
  -- },

  -- neorg
  {
    "nvim-neorg/neorg",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = ":Neorg sync-parsers",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},  -- Loads default behaviour
          ["core.concealer"] = {}, -- Adrs pretty icons to your documents
          ["core.dirman"] = {      -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/sanctum/org",
              },
            },
          },
          ["core.esupports.indent"] = {},
          ["core.clipboard.code-blocks"] = {},
          ["core.export"] = {
          },
        },
      }
    end,
  },

  ----------------------------------------------------------------------
  -- その他
  ----------------------------------------------------------------------
  -- 対応する文字を閉じる
  {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup {
        options = {
          disable_when_touch = true,
          touch_regex = "[%w(%[{ぁ-んァ-ヶー一-龯]"
        },
      }
    end,
  },

  {
    "RRethy/nvim-treesitter-endwise",
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

  -- 利用可能なキーマップを表示
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300

      require("which-key").setup {}
    end,
  },

  -- git
  {
    "NeogitOrg/neogit",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "sindrets/diffview.nvim", lazy = true },
      { "nvim-telescope/telescope.nvim", lazy = true },
    },
    config = function()
      require("neogit").setup {}
    end,
    enable = false,
  },

  -- 外部ツールのインストール
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup {}
    end,
    enable = false,
  },
}
