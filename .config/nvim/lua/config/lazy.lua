--- lazyのインストールを行い、パスを設定する
local function install()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    }
  end

  vim.opt.rtp:prepend(lazypath)
end

local function setup()
  -- プラグインをロードする
  require("lazy").setup("plugins", {
    dev = {
      path = "~/sanctum/projects",
    },
  })
end

install()
setup()
