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
  },

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
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {
        options = {
          mode = "tabs",
          numbers = "ordinal",
          name_formatter = "name",
          show_buffer_icons = true,
          sort_by = "tabs"
        },
      }
    end
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
    config = function()
      -- Eviline config for lualine
      -- Author: shadmansaleh
      -- Credit: glepnir
      local lualine = require("lualine")

      -- Color table for highlights
      -- stylua: ignore
      local colors = {
        bg       = "#303338",
        fg       = "#bbc2cf",
        yellow   = "#ECBE7B",
        cyan     = "#008080",
        darkblue = "#081633",
        green    = "#98be65",
        orange   = "#FF8800",
        violet   = "#a9a1e1",
        magenta  = "#c678dd",
        blue     = "#51afef",
        red      = "#ec5f67",
      }

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand("%:p:h")
          local gitdir = vim.fn.finddir(".git", filepath .. ";")
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      -- Config
      local config = {
        options = {
          -- Disable sections and component separators
          component_separators = "",
          section_separators = "",
          theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
          },
        },
        sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          -- These will be filled later
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      -- Inserts a component in lualine_c at left section
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      -- Inserts a component in lualine_x at right section
      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      ins_left {
        function()
          return "▊"
        end,
        color = { fg = colors.blue }, -- Sets highlighting of component
        padding = { left = 0, right = 1 }, -- We don"t need space before this
      }

      ins_left {
        -- mode component
        function()
          return ""
        end,
        color = function()
          -- auto change color according to neovims mode
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1 },
      }

      ins_left {
        -- filesize component
        "filesize",
        cond = conditions.buffer_not_empty,
      }

      ins_left {
        "filename",
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = "bold" },
      }

      ins_left { "location" }

      ins_left { "progress", color = { fg = colors.fg, gui = "bold" } }

      ins_left {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        diagnostics_color = {
          color_error = { fg = colors.red },
          color_warn = { fg = colors.yellow },
          color_info = { fg = colors.cyan },
        },
      }

      -- Insert mid section. You can make any number of sections in neovim :)
      -- for lualine it"s any number greater then 2
      ins_left {
        function()
          return "%="
        end,
      }

      ins_left {
        -- Lsp server name .
        function()
          local msg = "No Active Lsp"
          local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = " LSP:",
        color = { fg = "#ffffff", gui = "bold" },
      }

      -- Add components to right sections
      ins_right {
        "o:encoding", -- option component same as &encoding in viml
        fmt = string.upper, -- I"m not sure why it"s upper case either ;)
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = "bold" },
      }

      ins_right {
        "fileformat",
        fmt = string.upper,
        icons_enabled = false, -- I think icons are cool but Eviline doesn"t have them. sigh
        color = { fg = colors.green, gui = "bold" },
      }

      ins_right {
        "branch",
        icon = "",
        color = { fg = colors.violet, gui = "bold" },
      }

      ins_right {
        "diff",
        -- Is it me or the symbol for modified us really weird
        symbols = { added = " ", modified = "󰝤 ", removed = " " },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      }

      ins_right {
        function()
          return "▊"
        end,
        color = { fg = colors.blue },
        padding = { left = 1 },
      }

      -- Now don"t forget to initialize lualine
      lualine.setup(config)
    end,
    enabled = true,
  },

  ----------------------------------------------------------------------
  -- ファイラー
  ----------------------------------------------------------------------
  { "lambdalisue/fern.vim" },

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
  },

  {
    "notjedi/nvim-rooter.lua",
    lazy = false,
    config = function()
      require("nvim-rooter").setup {}
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -s. -bbuild -dcmake_build_type=release && cmake --build build --config release && cmake --install build --prefix build",
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

  {
    "onsails/lspkind.nvim",
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
    config = function()
      -- cf. <https://github.com/mrcjkb/haskell-tools.nvim>
      local ht = require("haskell-tools")
      local bufnr = vim.api.nvim_get_current_buf()
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- haskell-language-server relies heavily on codeLenses,
      -- so auto-refresh (see advanced configuration) is enabled by default
      vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, opts)

      -- Hoogle search for the type signature of the definition under the cursor
      vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, opts)

      -- Evaluate all code snippets
      vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts)

      -- Toggle a GHCi repl for the current package
      vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)

      -- Toggle a GHCi repl for the current buffer
      vim.keymap.set("n", "<leader>rf", function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, opts)

      vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)
    end,
  },

  {
    "purescript-contrib/purescript-vim"
  },

  { "hylang/vim-hy" },

  {
    "chrismaher/vim-lookml",
    enabled = false,
  },

  { "posva/vim-vue" },

  -- 色コードを彩色
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {
        "*",
      }
    end,
  },

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
          highlight = { enabled = true },
          enter = { shift = true },
          links = { external = { enabled = true } },
          toc = { text = "Table of Contents", update_on_write = true },
          fold = { enabled = false },
        },
      }
    end,
  },

  { "dhruvasagar/vim-table-mode" },

  -- markdown内のコードブロック内をシンタックスハイライト
  -- {
  --   "yaocccc/nvim-hl-mdcodeblock.lua",
  --   -- after = "nvim-treesitter",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require("hl-mdcodeblock").setup {}
  --   end,
  -- },

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
  --   enabled = false,
  -- },

  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },

  -- neorg
  {
    "nvim-neorg/neorg",
    dependencies = { "nvim-lua/plenary.nvim", "vhyrro/luarocks.nvim" },
    lazy = false,
    version = "*",
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

  {
    "ariel-frischer/bmessages.nvim",
    event = "CmdlineEnter",
    opts = {}
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
    enabled = false,
  },

  -- 外部ツールのインストール
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup {}
    end,
    enabled = false,
  },
}
