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
    build = function()
      local ts_update = require("nvim-treesitter.install").update {
        with_sync = true,
      }
      ts_update()
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
            local root = utils.get_root(path)
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
    dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
    opts = {
      options = {
        theme = "base16",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
    },
    enabled = true,
  },

  ----------------------------------------------------------------------
  -- ファイラー
  ----------------------------------------------------------------------
  { "lambdalisue/vim-fern" },

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
        open_mapping = "<C-;>",
      }
    end,
    enabled = true,
  },

  {
    "watanany/tabtoggleterm.nvim",
    config = function()
      require("tabtoggleterm").setup {
        size = 20,
        persist_size = true,
      }
    end,
    enabled = true,
    dev = true,
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
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        -- suggestion = { enabled = false },
        -- panel = { enabled = false },
      }
    end,
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

  -- cursor
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "openai",
      auto_suggestion_provider = "openai",
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'

      -- LaTeXやMarkdownのようなマークアップ言語に画像を組み込む
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
            use_absolute_path = true,
          },
        },
      },

      -- markdownを綺麗に表示
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = {
            "markdown",
            "Avante",
          },
        },
        ft = { "markdown", "Avante" },
      },
    },
    enabled = false,
  },

  -- Claude Code
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end,
    enabled = false,
  },

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
    enabled = true,
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
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
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
