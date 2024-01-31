-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[
--   packadd packer.nvim
-- ]]

local function ensure_packer()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    vim.cmd [[
      packadd packer.nvim
    ]]
    return true
  else
    return false
  end
end

local packer_bootstrap = ensure_packer()

local function startup(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"
  -- Configurations for Nvim LSP
  use "neovim/nvim-lspconfig"

  -- カラースキーム
  use "w0ng/vim-hybrid"

  --
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  }

  -- カーソル移動加速プラグイン
  use "rainbowhxch/accelerated-jk.nvim"

  -- f + 一文字で検索
  use "rhysd/clever-f.vim"

  -- セッション管理
  use {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/" },
      }
    end,
  }

  use {
    "Shatur/neovim-session-manager",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("session_manager").setup {}
    end,
  }

  -- タブ制御
  use {
    "crispgm/nvim-tabline",
    config = function()
      require("tabline").setup {}
    end,
  }

  -- ファイラー
  use "lambdalisue/fern.vim"

  -- fzf本体(CLI)
  use {
    "junegunn/fzf",
    run = ":call fzf#install()",
    disable = true,
  }

  -- vim用のfzfプラグイン
  use {
    "junegunn/fzf.vim",
    setup = function()
      -- fzfのコマンドのプレフィックスを設定(e.g. :Files -> :FzfFiles)
      vim.g.fzf_command_prefix = "Fzf"
    end,
    disable = true,
  }

  -- ファジーファインダー
  use {
    "nvim-telescope/telescope.nvim",
    tag = "*",
    requires = { "nvim-lua/plenary.nvim" },
  }

  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  }

  use {
    "nvim-telescope/telescope-project.nvim",
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      require("telescope").load_extension("project")
    end,
  }

  use {
    "smartpde/telescope-recent-files",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("recent_files")
    end,
  }

  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension("frecency")
    end,
  }

  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {}
      require("telescope").load_extension("projects")
    end,
  }

  -- ターミナルをトグルする機能を追加
  use {
    "watanany/tabtoggleterm.nvim",
    config = function()
      require("tabtoggleterm").setup {
        size = 20,
      }
    end,
  }

  -- ターミナル内でneovimを開けるようにする
  use {
    "samjwill/nvim-unception",
    setup = function()
      vim.g.unception_open_buffer_in_new_tab = true
    end,
  }

  -- 対応する文字を閉じる
  use {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup {
        options = {
          disable_when_touch = true,
          touch_regex = "[%w(%[{ぁ-んァ-ヶー一-龯]"
        },
      }
    end,
  }

  use {
    "RRethy/nvim-treesitter-endwise",
    requires = { "nvim-treesitter/nvim-treesitter" },
  }

  -- surroundを追加
  use {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup {}
    end,
  }

  -- ファイル保存時にLSPでフォーマットする
  -- use {
  --   "lukas-reineke/lsp-format.nvim",
  --   config = function()
  --     require("lsp-format").setup {}
  --   end,
  -- }

  --
  use {
    "rcarriga/nvim-notify",
    setup = function()
      vim.o.termguicolors = true
    end,
    config = function()
      vim.notify = require("notify")
    end,
  }

  -- スニペット
  use "hrsh7th/cmp-vsnip"
  use "hrsh7th/vim-vsnip"

  -- 補完プラグライン
  use {
    "hrsh7th/nvim-cmp",
  }

  use {
    "hrsh7th/cmp-nvim-lsp",
    requires = { "hrsh7th/nvim-cmp" },
  }

  use {
    "hrsh7th/cmp-buffer",
    requires = { "hrsh7th/nvim-cmp" },
  }

  use {
    "hrsh7th/cmp-path",
    requires = { "hrsh7th/nvim-cmp" },
  }

  use {
    "hrsh7th/cmp-cmdline",
    requires = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-buffer" },
  }

  use {
    "hrsh7th/cmp-nvim-lua",
    requires = { "hrsh7th/nvim-cmp" },
  }

  use {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup {}
    end,
  }

  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  }

  use {
    "zbirenbaum/copilot-cmp",
    requires = { "zbirenbaum/copilot.lua" },
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  }

  -- 利用可能なキーマップを表示
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300

      require("which-key").setup {}
    end,
  }

  -- git
  use {
    "NeogitOrg/neogit",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "sindrets/diffview.nvim",        opt = true },
      { "nvim-telescope/telescope.nvim", opt = true },
    },
    config = function()
      require("neogit").setup {}
    end,
  }

  -- -- org-mode
  use {
    "nvim-orgmode/orgmode",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local orgmode = require("orgmode")
      orgmode.setup {
        org_agenda_files = { "~/sanctum/org/**/*.org" },
      }
    end,
    disable = true
  }

  use {
    "nvim-neorg/neorg",
    requires = { "nvim-lua/plenary.nvim" },
    run = ":Neorg sync-parsers",
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
        },
      }
    end,
  }

  -- TODOコメントのハイライト
  -- インストール方法(brew):
  --   $ brew tap homebrew/cask-fonts
  --   $ brew install font-hack-nerd-font
  use {
    "folke/todo-comments.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup {
        highlight = {
          keyword = "fg",
          after = "",
          pattern = "(KEYWORDS):",
        },
      }
    end,
  }

  -- CSVを見やすく色付け
  use "mechatroner/rainbow_csv"

  -- markdown
  use {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup {}
    end,
  }

  use {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  }

  use {
    "SidOfc/mkdx",
    setup = function()
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
  }

  use "dhruvasagar/vim-table-mode"

  -- markdown内のコードブロック内をシンタックスハイライト
  use {
    "yaocccc/nvim-hl-mdcodeblock.lua",
    after = "nvim-treesitter",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("hl-mdcodeblock").setup {}
    end,
  }

  -- hy
  use "hylang/vim-hy"

  -- インデントガイドラインの追加
  use {
    "lukas-reineke/indent-blankline.nvim",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("ibl").setup {
        scope = { enabled = false },
      }
    end,
  }

  -- 外部ツールのインストール
  use {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup {}
    end,
    disable = true,
  }

  -- LookML
  use "chrismaher/vim-lookml"

  --
  use {
    "mrcjkb/haskell-tools.nvim",
  }

  -- packerがインストールされた初回のみPackerSyncを行う
  if packer_bootstrap then
    require("packer").sync()
  end
end

local config = {
  display = {
    -- :PackerSyncとかするときに出るディスプレイの設定
    -- <https://github.com/wbthomason/packer.nvim#using-a-floating-window>
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
}

return require("packer").startup {
  startup,
  config = config,
}
