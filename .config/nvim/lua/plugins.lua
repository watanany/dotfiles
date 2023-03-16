-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[
--   packadd packer.nvim
-- ]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Configurations for Nvim LSP
  use 'neovim/nvim-lspconfig'

  -- カラースキーム
  use 'w0ng/vim-hybrid'

  -- カーソル移動加速プラグイン
  use 'rainbowhxch/accelerated-jk.nvim'

  -- f + 一文字で検索
  use 'rhysd/clever-f.vim'
end)
