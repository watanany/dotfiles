local constants = require("constants")

return {
  ----------------------------------------------------------------------
  -- 基盤
  -- LSP・構文解析・Lua開発補助など、他プラグインが依存する基礎的なもの
  ----------------------------------------------------------------------
  -- LSP設定の基盤(各言語サーバーの設定はconfig/lsps.luaで行う)
  { "neovim/nvim-lspconfig" },

  -- LSPのdocumentLinkをgxで開く(terraform-lsのRegistryリンク等)
  {
    "icholy/lsplinks.nvim",
    opts = {},
    keys = {
      { "gx", function() require("lsplinks").gx() end },
    },
  },

  -- Lua関数集(多くのプラグインが依存)
  { "nvim-lua/plenary.nvim" },

  -- 構文解析エンジン(シンタックスハイライト・テキストオブジェクトの基盤)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- FIXME:
      -- すでにパスは入っているがcheckhealthでエラーになっている
      -- treesitter側のバグの可能性あり
      vim.opt.runtimepath:append(
        vim.fn.stdpath("data") .. "/site/"
      )

      -- Lean 4 は公式パーサ一覧に無いためカスタム登録
      -- (nvim-treesitter はアーカイブ済みのため revision もピン留め)
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").lean = {
            install_info = {
              url = "https://github.com/Julian/tree-sitter-lean",
              revision = "dc5997b2744595eeb389e1ed9c4f5e727c5b655e",
              queries = "queries", -- リポジトリ同梱の highlights.scm 等も入れる
            },
          }
        end,
      })

      local treesitter = require("nvim-treesitter")
      treesitter.setup()
      treesitter.install {
        "lua", "bash", "regex", "python", "sql",
        "markdown", "javascript", "rust", "haskell",
        "lean",
      }
    end,
  },

  -- Neovim Lua開発補助(型定義・補完)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- vim.uv が登場する箇所に luv の型定義を補完する
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- JSONSchema・YAMLスキーマ定義(jsonls/yamllsで使用)
  { "b0o/schemastore.nvim" },

  ----------------------------------------------------------------------
  -- 外観・UI
  -- カラースキーム・タブライン・ステータスライン・インデントガイドなど
  ----------------------------------------------------------------------
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

  -- タブラインをタブモードで表示(プロジェクト名短縮・◆マーク表示)
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

        -- タブ名を整形する：タブのcwdからプロジェクト名を引き、末尾セグメントのみ表示する。
        -- フォーカス中のバッファに依存しないので、terminal buffer(fish/claude等)に
        -- フォーカスを移してもラベルが変わらない。
        name_formatter = function(buf)
          -- このバッファが属するタブ番号を特定する(1番最初)
          local tabnr
          for i, tp in ipairs(vim.api.nvim_list_tabpages()) do
            local win = vim.api.nvim_tabpage_get_win(tp)
            if vim.api.nvim_win_get_buf(win) == buf.bufnr then
              tabnr = i
              break
            end
          end

          -- タブのcwd(tab-local cwdが無ければglobal cwd)からプロジェクト名を取る
          local cwd = tabnr and vim.fn.getcwd(-1, tabnr) or vim.fn.getcwd()
          local root = vim.fs.root(cwd, { ".git" }) or cwd
          local name = vim.fs.basename(root)
          local parts = vim.split(name, "-")
          return parts[#parts]
        end,

        show_buffer_icons = true,
        sort_by = "tabs",
      }
    },
    enabled = true,
  },

  -- ステータスライン
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

  -- インデントガイドラインの追加
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",

    ---@module "ibl"
    ---@type ibl.config
    opts = {
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "markdown",
          "lean",
        },
      },
    },
  },

  -- 色コードを彩色する
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" },
    },
  },

  ----------------------------------------------------------------------
  -- Git
  ----------------------------------------------------------------------
  -- 行ごとのgit差分マーク表示(キーマップなし、操作はlazygitで行う)
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

  -- git-blame(デフォルト無効、<Leader>tb でトグル)
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

  ----------------------------------------------------------------------
  -- 移動・検索
  ----------------------------------------------------------------------
  -- カーソル移動加速プラグイン
  { "rainbowhxch/accelerated-jk.nvim" },

  -- f + 一文字で検索(clever-fはファイル内の文字に直接ジャンプできる)
  { "rhysd/clever-f.vim", enabled = true },

  -- ファジーファインダー・通知・プロジェクト管理
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      -- ファイル・バッファ・プロジェクト検索のpicker
      picker = {
        enabled = true,
        -- 入力欄を下部に配置(Telescope風レイアウト)
        layout = { preset = "telescope" },
        -- ファイルを開く対象を「picker起動時のカレントウィンドウ」に固定する
        -- (デフォルトはlastused順で隣のwindowに開きうる)
        main = { current = true },
        sources = {
          -- Claude Code の会話の一覧(vim.ui.select の kind)を他の picker と同じ大きさで出し、会話をプレビューする
          select = {
            kinds = {
              claude_session = {
                layout = { preset = "telescope" },
                preview = function(ctx)
                  ctx.preview:reset()
                  ctx.preview:set_title(ctx.item.item.title)
                  require("claude-history.preview").render_preview(ctx.buf, ctx.win, ctx.item.item)
                  ctx.preview:highlight({ ft = "markdown" })
                end,
              },
            },
          },
          -- ファイルツリー(drawerスタイル)。隠しファイルも表示する
          explorer = {
            hidden = true,
          },
          projects = {
            -- サブディレクトリをスキャンしてプロジェクトを検出(新規作成分も即反映)
            dev = { "~/sanctum/projects", "~/sanctum/goals" },
            -- これら自体がプロジェクト(.git を持つので直接指定)
            -- vim.fn.expand で絶対パスに展開：vim.v.oldfiles 経由の登録と重複しないようにする
            projects = {
              vim.fn.expand("~/dotfiles"),
              vim.fn.expand("~/sanctum/org"),
              vim.fn.expand("~/sanctum/knowledge"),
            },

            -- デフォルトの load_session を上書き：CWD変更のみ行いファイル一覧を開く
            confirm = function(picker, item)
              picker:close()
              if item then
                vim.fn.chdir(item.file)
                Snacks.picker.files({ cwd = item.file, hidden = true })
              end
            end,

          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "i" } },
              ["<C-;>"] = { "close", mode = { "i", "n" } },
              ["<C-q>"] = { "close", mode = { "i", "n" } },
              -- insert modeのEmacsバインドを解放(normal modeは元のpicker動作を維持)
              -- Snacksのデフォルトがi/n両方に設定されているキーをnormal modeのみに限定する
              ["<C-a>"] = { "select_all",        mode = { "n" } },
              ["<C-b>"] = { "preview_scroll_up", mode = { "n" } },
              ["<C-d>"] = { "list_scroll_down",  mode = { "n" } },
              ["<C-f>"] = { "preview_scroll_down", mode = { "n" } },
              ["<C-k>"] = { "list_up",           mode = { "n" } },
            },
          },
        },
      },
      -- 通知表示(nvim-notifyの代替)
      notifier = { enabled = true },
      -- ファイルツリー(普段はpicker中心。共有時など、たまにツリー表示したい用)
      explorer = { enabled = true },
    },
    keys = {
      -- ファイル検索
      {
        "<Leader>ff",
        function() Snacks.picker.files({ hidden = true }) end,
        desc = "ファイル名で検索する",
      },
      {
        "<Leader>pf",
        function()
          Snacks.picker.files({
            hidden = true,
            cwd = vim.fs.root(vim.api.nvim_buf_get_name(0), { ".git" }),
          })
        end,
        desc = "プロジェクトのファイルを検索する",
      },
      {
        "<Leader>fp",
        function()
          Snacks.picker.files({ cwd = "~/dotfiles", hidden = true })
        end,
        desc = "dotfilesを検索する",
      },
      {
        "<Leader>fd",
        function()
          Snacks.picker.files({ cwd = vim.fn.expand("%:h"), hidden = true })
        end,
        desc = "ファイル名で検索する(cwd=%:h)",
      },

      -- grep
      {
        "<Leader>fs",
        function() Snacks.picker.grep({ hidden = true }) end,
        desc = "ファイル内の文字列を検索する",
      },
      {
        "<Leader>sp",
        function()
          Snacks.picker.grep({
            hidden = true,
            cwd = vim.fs.root(vim.api.nvim_buf_get_name(0), { ".git" }),
          })
        end,
        desc = "プロジェクト内の文字列を検索する",
      },
      {
        "<Leader>sd",
        function()
          Snacks.picker.grep({ cwd = vim.fn.expand("%:h"), hidden = true })
        end,
        desc = "ファイル内の文字列を検索する(cwd=%:h)",
      },

      -- バッファ
      { "<Leader>fb", function() Snacks.picker.buffers() end, desc = "バッファ一覧を表示する" },
      { "<Leader>bB", function() Snacks.picker.buffers() end, desc = "バッファ一覧を表示する" },
      { "<Leader>bl", function() Snacks.picker.buffers() end, desc = "バッファ一覧を表示する" },

      -- その他
      { "<Leader>fh", function() Snacks.picker.help() end, desc = "ヘルプを表示する" },
      {
        "<Leader>fr",
        function() Snacks.picker.recent() end,
        desc = "最近開いたファイルで検索する",
      },
      {
        "<Leader>fR",
        function() Snacks.picker.recent({ cwd = vim.fn.getcwd() }) end,
        desc = "最近開いたファイルで検索する(workspace=CWD)",
      },
      { "<Leader>pp", function() Snacks.picker.projects() end, desc = "プロジェクトを開く" },
      { "<Leader>n", function() Snacks.picker.notifications() end, desc = "通知履歴" },
      {
        "<Leader>gf",
        function() Snacks.picker.git_files({ hidden = true }) end,
        desc = "Gitファイルを検索する",
      },

      -- ファイルツリー
      { "<Leader>ft", function() Snacks.explorer() end, desc = "ファイルツリーを開く" },
    },
  },

  ----------------------------------------------------------------------
  -- セッション管理
  ----------------------------------------------------------------------
  -- Neovim起動時に前回のタブ・バッファ構成を自動復元する
  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      local session_config = require("session_manager.config")
      local no_session = os.getenv("NVIM_NO_SESSION") ~= nil

      require("session_manager").setup {
        autoload_mode = no_session and session_config.AutoloadMode.Disabled
          or session_config.AutoloadMode.LastSession,
        autosave_last_session = not no_session,
      }

      -- プラグインの VimLeavePre は nested でなく、終了時の保存で SessionWritePost が発火しないため、nested で登録し直す
      vim.api.nvim_clear_autocmds({ group = "SessionManager", event = "VimLeavePre" })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = "SessionManager",
        nested = true,
        callback = require("session_manager").autosave_session,
      })
    end,
    enabled = true,
  },

  ----------------------------------------------------------------------
  -- ターミナル・外部ツール
  ----------------------------------------------------------------------
  -- ターミナル内でneovimを開いたとき、新しいインスタンスを起動せず
  -- 親のneovimでファイルを開けるようにする
  {
    "samjwill/nvim-unception",
    init = function()
      vim.g.unception_open_buffer_in_new_tab = true
    end,
  },

  -- lazygit・lazydocker・claude等をトグルで開く(自作プラグイン)
  -- 起動時のセッション読み込みで、claude の terminal を kocmd のウィンドウとして扱うため、遅延ロードしない
  {
    "watanany/kocmd.nvim",
    lazy = false,
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
        "<Leader>oh",
        function()
          require("kocmd").toggle("hunk")
        end,
        desc = "Toggle hunk diff",
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
        hunk = {
          cmd = "hunk diff",
          position = "float",
          size = { width = 0.95, height = 0.95 },
        },
        lazydocker = {
          cmd = "lazydocker",
          position = "float",
          size = { width = 0.95, height = 0.95 },
        },
        -- claude-term の dtach の中で動かす。起動のたびに新しいソケットを作るので、cmd は関数で渡す
        -- セッションに保存し、読み込み時は動いている claude につなぎ直す(止まっていれば元の会話を --resume で再開する)
        claude = {
          cmd = function()
            return require("claude-term").cmd()
          end,
          position = "left",
          size = 60,
          session = true,
          restore_cmd = function(buf)
            return require("claude-term").restore_cmd(buf)
          end,
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

  -- Claude Code を dtach の中で動かし、Neovim を閉じても止めない。会話の一覧・resume・つなぎ直し(自作プラグイン)
  -- 起動時のセッション読み込みで claude の terminal をつなぎ直すため、遅延ロードしない
  {
    "watanany/claude-term.nvim",
    main = "claude-term",
    lazy = false,
    opts = {
      dtach = true,
      -- 起動時の通知はすぐ消えて :ClaudeAttach を打つ間がないので出さない。裏の claude は <Leader>ad で見る
      notify_detached = false,
      -- kocmd の terminal は kocmd が自分でセッションファイルを書き換えるので、claude-term では扱わない
      session_skip = function(buf)
        return vim.b[buf].kocmd_name ~= nil
      end,
    },
    dev = true,
  },

  -- Claude Code の会話の live grep と AI 検索(自作プラグイン)
  {
    "watanany/claude-history.nvim",
    main = "claude-history",
    dependencies = { "folke/snacks.nvim", "watanany/claude-term.nvim" },
    opts = {},
    dev = true,
  },

  ----------------------------------------------------------------------
  -- 補完
  ----------------------------------------------------------------------
  -- 高速非同期補完エンジン(nvim-cmpの後継)
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      -- 汎用スニペット集(vim-vsnipの代替)
      "rafamadriz/friendly-snippets",
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      -- キーマップ：Emacsバインドとの衝突を回避
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "fallback" },
        ["<C-q>"]     = { "hide", "fallback" },
        ["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"]      = { "accept", "fallback" },
        ["<Up>"]      = { "select_prev", "fallback" },
        ["<Down>"]    = { "select_next", "fallback" },
        ["<C-p>"]     = { "select_prev", "fallback" },
        ["<C-n>"]     = { "select_next", "fallback" },
      },

      appearance = {
        -- nerd fontを使用している場合は "mono"
        nerd_font_variant = "mono",
      },

      -- 補完ソース設定
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          -- lazydev(Lua開発補助)を最優先に表示する
          lazydev = {
            name         = "LazyDev",
            module       = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
  },

  ----------------------------------------------------------------------
  -- 言語サポート
  -- 各言語のシンタックス・LSP統合・フォーマッタなど
  ----------------------------------------------------------------------
  -- Haskell(LSP統合・GHCi連携)
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^4",
    lazy = false,
  },

  -- Haskell cabalフォーマッタ
  { "sdiehl/vim-cabalfmt" },

  -- PureScript
  { "purescript-contrib/purescript-vim" },

  -- Hy(Python上で動くLisp方言)
  { "hylang/vim-hy" },

  -- Vue.js
  { "posva/vim-vue" },

  -- F#
  { "adelarsq/neofsharp.vim" },

  -- Lean 4(定理証明支援言語)
  {
    "Julian/lean.nvim",
    -- BufReadPre *.lean で遅延ロードすると、セッション復元時にその .lean
    -- バッファの filetype 検出が走らず &ft が空のままになることがある。
    -- ft= なら Neovim 組み込みの検出が先に動いて FileType が発火し、それを
    -- きっかけにプラグインがロードされるので、検出が確実に行われる。
    ft = "lean",

    dependencies = {
      -- optional dependencies:

      -- "nvim-telescope/telescope.nvim", -- for Lean-specific pickers
      -- "andymass/vim-matchup",          -- for enhanced % motion behavior
      -- "andrewradev/switch.vim",        -- for switch support
      -- "tomtom/tcomment_vim",           -- for commenting
    },

    init = function()
      ---@module "lean"
      ---@type lean.Config
      vim.g.lean_config = {
        mappings = true,
      }
    end,
  },

  -- Flix
  {
    "flix/nvim",
    opts = {},
  },

  -- Fennel(Lua上で動くLisp方言)
  {
    "Olical/nfnl",
    ft = "fennel",
  },

  -- CSVを見やすく色付け
  { "mechatroner/rainbow_csv" },

  ----------------------------------------------------------------------
  -- ドキュメント・Markdown
  ----------------------------------------------------------------------
  -- Markdownをneovim内でプレビュー(:Glow)
  {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup {}
    end,
  },

  -- Markdownのキーマップ追加(テーブル操作・見出し操作など)
  {
    "SidOfc/mkdx",
    init = function()
      vim.g["mkdx#settings"] = {
        highlight = { enable = 1 },
        enter = { shift = 1 },
        links = {
          external = { enable = 1 },
          fragment = { complete = 0 },
        },
        toc = { text = "Table of Contents", update_on_write = 1 },
        fold = { enable = 0 },
      }
    end,
    enabled = true,
  },

  -- Markdownをneovim上でリアルタイムレンダリング
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {},
    enabled = false,
  },

  -- Markdown を near-WYSIWYG 描画
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      preview = {
        modes = { "n", "no", "c" },
        -- hybrid_modes = { "i" },
      },
    },
    enabled = false,
  },

  -- Obsidian vault 操作([[wikilink]]補完・リンク追跡・バックリンク・デイリーノート)
  -- 補完は obsidian-ls(内蔵LSP・vault内のみ)+ blink.cmp の "lsp" ソース経由
  -- 描画は 別プラグインに任せるので ui は無効化
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    ---@module "obsidian"
    ---@type obsidian.config
    opts = {
      workspaces = {
        { name = "org", path = "~/sanctum/org" },
      },
      picker = { name = "snacks.picker" },
      ui = { enable = false },
      legacy_commands = false,
    },
    enabled = false,
  },

  -- Markdownのテーブル作成とフォーマット
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("TableModeEnable")
        end,
      })
      -- プラグイン初回ロードを引き起こしたバッファにも適用
      if vim.bo.filetype == "markdown" then
        vim.cmd("TableModeEnable")
      end
    end,
  },

  -- MarkdownなどをWEBブラウザでのlive-preview
  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
  },

  -- 画像をneovim内で表示
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
    },
    enabled = true,
  },

  ----------------------------------------------------------------------
  -- エディタ拡張
  -- テキスト編集・UI補助・ユーティリティ
  ----------------------------------------------------------------------
  -- endを自動で補完する(RubyやLuaのブロック末尾)
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- treesitterでtextobjectを設定できるようにする(関数・クラス単位で選択など)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- surroundを追加(cs"'でクォートを変換、ds"でsurroundを削除など)
  {
    "kylechui/nvim-surround",
    version = "*", -- for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  -- TODOコメントのハイライト(TODO: FIXME: NOTE: など)
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

  -- 利用可能なキーマップをポップアップで表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- :messagesをバッファとして表示(:Bmessages)
  {
    "ariel-frischer/bmessages.nvim",
    event = "CmdlineEnter",
    opts = {},
  },

  -- windowを消さないbdコマンド(:Bdeleteと:Bwipeoutを追加)
  { "famiu/bufdelete.nvim" },

  -- ウィンドウサイズ変更
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<S-Left>", function() require("smart-splits").resize_left() end, desc = "ウィンドウの境界を左へ" },
      { "<S-Right>", function() require("smart-splits").resize_right() end, desc = "ウィンドウの境界を右へ" },
      { "<S-Up>", function() require("smart-splits").resize_up() end, desc = "ウィンドウの境界を上へ" },
      { "<S-Down>", function() require("smart-splits").resize_down() end, desc = "ウィンドウの境界を下へ" },
    },
    opts = {
      multiplexer_integration = false,
      default_amount = 3,
    },
  },

  {
    "folke/zen-mode.nvim",
    keys = {
      {
        "<Leader>tz",
        function()
          require("zen-mode").toggle()
        end,
        desc = "ZenModeをトグルする",
      },
    },
    opts = {
      -- ZenMode中はインデントガイド(indent-blankline)を非表示にする
      on_open = function()
        require("ibl").update { enabled = false }
        -- require("markview").commands.disable(vim.api.nvim_get_current_buf())
      end,
      on_close = function()
        require("ibl").update { enabled = true }
        -- require("markview").commands.enable(vim.api.nvim_get_current_buf())
      end,
      window = {
        width = 0.85,
        options = {
          wrap = false,            -- disable wrap
          signcolumn = "no",       -- disable signcolumn
          number = false,          -- disable number column
          relativenumber = false,  -- disable relative numbers
          cursorline = false,      -- disable cursorline
          cursorcolumn = false,    -- disable cursor column
          foldcolumn = "0",        -- disable fold column
          list = false,            -- disable whitespace characters
        },
      },
    },
  },
}
