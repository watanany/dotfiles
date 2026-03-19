-- Tree-sitterベースのインデントをONにする
vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
