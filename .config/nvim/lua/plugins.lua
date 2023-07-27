-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[
--   packadd packer.nvim
-- ]]

local function ensure_packer()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
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

  -- カーソル移動加速プラグイン
  use "rainbowhxch/accelerated-jk.nvim"

  -- f + 一文字で検索
  use "rhysd/clever-f.vim"

  -- セッション管理
  use "rmagatti/auto-session"

  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- ファイラー
  use "lambdalisue/fern.vim"

  -- fzf本体(CLI)
  use { "junegunn/fzf", run = ":call fzf#install()" }
  -- vim用のfzfプラグイン
  use "junegunn/fzf.vim"

  use { "nvim-telescope/telescope.nvim", tag = "0.1.1", requires = {{"nvim-lua/plenary.nvim"}} }
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  }
  use {
    "nvim-telescope/telescope-project.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-telescope/telescope-file-browser.nvim" },
  }
  use {
    "smartpde/telescope-recent-files",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("recent_files")
    end
  }

  use { 
    "akinsho/toggleterm.nvim",
    tag = "*", 
    config = function()
      require("toggleterm").setup()
    end
  }

  -- CSVを見やすく色付け
  use "mechatroner/rainbow_csv"

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
      return require("packer.util").float({ border = "single" })
    end
  },
}

return require("packer").startup({ startup, config = config })