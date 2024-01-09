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

  -- 利用可能なキーマップを表示
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300

      require("which-key").setup {}
    end
  }

  -- ファイラー
  use "lambdalisue/fern.vim"

  -- fzf本体(CLI)
  use { "junegunn/fzf", run = ":call fzf#install()" }
  -- vim用のfzfプラグイン
  use "junegunn/fzf.vim"

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
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("toggleterm").setup {
        size = 20,
        -- open_mapping = "<space>ot",
      }
    end,
  }

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
        ["{"] = { escape = true, close = true, pair = "}", disabled_filetypes = {} },
        ["["] = { escape = true, close = true, pair = "[", disabled_filetypes = {} },
        ["("] = { escape = true, close = true, pair = ")", disabled_filetypes = {} },
      }
    end,
  }

  use {
    "RRethy/nvim-treesitter-endwise",
    requires = { "nvim-treesitter/nvim-treesitter" },
  }

  -- GitHub Copilot
  use "github/copilot.vim"

  -- surroundを追加
  use {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup {}
    end
  }

  -- CSVを見やすく色付け
  use "mechatroner/rainbow_csv"

  --
  use {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup {}
    end,
  }

  -- git
  use "sindrets/diffview.nvim"

  use {
    "NeogitOrg/neogit",
    requires = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("neogit").setup {}
    end,
  }

  -- タブ制御
  use {
    "crispgm/nvim-tabline",
    config = function()
      require("tabline").setup {}
    end,
  }

  -- org-mode
  -- use {
  --   "nvim-orgmode/orgmode",
  --   requires = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     local orgmode = require("orgmode")
  --     orgmode.setup_ts_grammer()
  --     orgmode.setup {
  --       org_agenda_files = { "~/sanctum/org/**/*.org" },
  --     }
  --   end,
  -- }

  -- hy
  use "hylang/vim-hy"

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
