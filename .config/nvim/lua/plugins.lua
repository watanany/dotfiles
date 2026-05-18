local utils = require("utils")

return {
  -- Configurations for Nvim LSP
  { "neovim/nvim-lspconfig" },

  -- カラースキーム
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

  ----------------------------------------------------------------------
  -- セッション管理
  ----------------------------------------------------------------------
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
          local label
          if vim.uv.fs_stat(buf.path) then
            local path = vim.api.nvim_buf_get_name(buf.bufnr)
            local root = vim.fs.root(path, { ".git" })
            local name = root and vim.fs.basename(root) or vim.fs.basename(path)
            local parts = vim.split(name, "-")
            label = parts[#parts]
          else
            label = buf.name
          end
          local tabpages = vim.api.nvim_list_tabpages()
          for i, tp in ipairs(tabpages) do
            local win = vim.api.nvim_tabpage_get_win(tp)
            if vim.api.nvim_win_get_buf(win) == buf.bufnr then
              if vim.fn.gettabvar(i, "claude_pending") == 1 then
                label = "◆ " .. label
              end
              break
            end
          end
          return label
        end,

        show_buffer_icons = true,
        sort_by = "tabs",
      }
    },
    enabled = true,
  },

  -- 行ごとのgit差分マーク表示（キーマップなし、操作はlazygitで行う）
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
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

  ----------------------------------------------------------------------
  -- ターミナル
  ----------------------------------------------------------------------
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
  -- 高速非同期補完エンジン（nvim-cmpの後継）
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      -- 汎用スニペット集（vim-vsnipの代替）
      "rafamadriz/friendly-snippets",
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      -- キーマップ：Emacsバインド（<C-b>/<C-f>/<C-e>/<C-k>）との衝突を回避
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "fallback" },
        ["<C-q>"]     = { "hide", "fallback" },
        ["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"]      = { "accept", "fallback" },
        ["<Up>"]      = { "select_prev", "fallback" },
        ["<Down>"]    = { "select_next", "fallback" },
      },

      appearance = {
        -- nerd fontを使用している場合は "mono"
        nerd_font_variant = "mono",
      },

      -- 補完ソース設定
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          -- lazydev（Lua開発補助）を最優先に表示する
          lazydev = {
            name         = "LazyDev",
            module       = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
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

  ----------------------------------------------------------------------
  -- その他
  ----------------------------------------------------------------------
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

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        sources = {
          projects = {
            dirs = {
              "~/dotfiles",
              "~/sanctum/org",
              "~/sanctum/projects",
              "~/sanctum/goals",
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "i" } },
              ["<C-;>"] = { "close", mode = { "i", "n" } },
              ["<C-q>"] = { "close", mode = { "i", "n" } },
            },
          },
        },
      },
      notifier = { enabled = true },
      session = { enabled = false },
    },
    keys = {
      { "<Leader>ff", function() Snacks.picker.files({ hidden = true }) end,
        desc = "ファイル名で検索する" },
      { "<Leader>pf", function()
          Snacks.picker.files({
            hidden = true,
            cwd = vim.fs.root(vim.api.nvim_buf_get_name(0), { ".git" }),
          })
        end, desc = "プロジェクトのファイルを検索する" },
      { "<Leader>fp", function()
          Snacks.picker.files({ cwd = "~/dotfiles", hidden = true })
        end, desc = "dotfilesを検索する" },
      { "<Leader>fd", function()
          Snacks.picker.files({ cwd = vim.fn.expand("%:h"), hidden = true })
        end, desc = "ファイル名で検索する(cwd=%:h)" },

      { "<Leader>fs", function() Snacks.picker.grep({ hidden = true }) end,
        desc = "ファイル内の文字列を検索する" },
      { "<Leader>sp", function()
          Snacks.picker.grep({
            hidden = true,
            cwd = vim.fs.root(vim.api.nvim_buf_get_name(0), { ".git" }),
          })
        end, desc = "プロジェクト内の文字列を検索する" },
      { "<Leader>sd", function()
          Snacks.picker.grep({ cwd = vim.fn.expand("%:h"), hidden = true })
        end, desc = "ファイル内の文字列を検索する(cwd=%:h)" },

      { "<Leader>fb", function() Snacks.picker.buffers() end, desc = "バッファ一覧を表示する" },
      { "<Leader>bB", function() Snacks.picker.buffers() end, desc = "バッファ一覧を表示する" },
      { "<Leader>bl", function() Snacks.picker.buffers() end, desc = "バッファ一覧を表示する" },

      { "<Leader>fh", function() Snacks.picker.help() end, desc = "ヘルプを表示する" },
      { "<Leader>fr", function() Snacks.picker.recent() end,
        desc = "最近開いたファイルで検索する" },
      { "<Leader>fR", function() Snacks.picker.recent({ cwd = vim.fn.getcwd() }) end,
        desc = "最近開いたファイルで検索する(workspace=CWD)" },
      { "<Leader>pp", function() Snacks.picker.projects() end, desc = "プロジェクトを開く" },
      { "<Leader>n",  function() Snacks.picker.notifications() end, desc = "通知履歴" },
      { "<Leader>gf", function() Snacks.picker.git_files({ hidden = true }) end,
        desc = "Gitファイルを検索する" },
    },
  },

  -- windowを消さないbdコマンド(:Bdeleteと:Bwipeoutを追加)
  { "famiu/bufdelete.nvim" },

  -- Lua
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- vim.uv が登場する箇所に luv の型定義を補完する
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- git-blame（デフォルト無効、<Leader>tb でトグル）
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = false,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%Y-%m-%d %H:%M:%S",
      virtual_text_column = 1,
    },
  },

  -- Lua Lisp
  {
    "Olical/nfnl",
    ft = "fennel",
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
