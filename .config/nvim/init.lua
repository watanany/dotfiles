require("plugins")

-- プラグイン管理ファイルに書き込みが行われた場合、PackerCompileを行うようにする
-- (test)
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

-- Vimスクリプトで使用されるエンコード
vim.scriptencoding = "utf-8"
-- エディタ内部で使用されるエンコード
vim.o.encoding = "utf-8"
-- 現在のバッファのファイル内容のエンコード
vim.o.fileencoding = "utf-8"
-- 行番号を表示する
vim.o.number = true
-- スクロールする時に下が見えるようにする
vim.o.scrolloff = 5
-- 不可視文字を表示
vim.o.list = true
vim.opt.listchars = {
  tab = "»-",
  trail = "-",
  extends = "»",
  precedes = "«",
  nbsp = "%",
  eol = "$",
}
-- 小文字の検索でも大文字も見つかるようにする
vim.o.ignorecase = true
-- ただし大文字も含めた検索の場合はその通りに検索する
vim.o.smartcase = true
-- ステータスラインを2行にする
vim.o.cmdheight = 2
-- カーソル移動の動作を変更
vim.o.whichwrap = "b,s,h,l,<,>,[,]"
-- ファイルを閉じてもundoできるようにする
vim.opt.undofile = true
-- クリップボードを設定する
vim.opt.clipboard:append("unnamedplus")

-- カラースキームの設定
vim.cmd [[
  try
    set background=dark
    colorscheme hybrid
  catch /E185/
    echo 'カラースキーム「hybrid」がインストールされていません。'
  endtry
]]

-- vim.g.mapleader = " "

-- fzfのコマンドのプレフィックスを設定(e.g. :Files -> :FzfFiles)
vim.g["fzf_command_prefix"] = "Fzf"  -- `let g:fzf_command_prefix = "Fzf"`と同じ意味

----------------------------------------------------------------------
-- キーバインド
----------------------------------------------------------------------
-- 入力モード中に素早くJJと入力した場合はESCとみなす
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
-- ESCを二回押すことでハイライトを消す
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })
-- Shift + 矢印でウィンドウサイズを変更
vim.keymap.set("n", "<S-Left>", "<C-w><", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Right>", "<C-w>>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Up>", "<C-w>-", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Down>", "<C-w>+", { noremap = true, silent = true })
-- 検索後にジャンプした際に検索単語を画面中央に持ってくる
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })
vim.keymap.set("n", "*", "*zz", { noremap = true, silent = true })
vim.keymap.set("n", "#", "#zz", { noremap = true, silent = true })
vim.keymap.set("n", "g*", "g*zz", { noremap = true, silent = true })
vim.keymap.set("n", "g#", "g#zz", { noremap = true, silent = true })
-- j, k, ↑, ↓での移動を加速する
vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", { silent = true })
vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", { silent = true })
vim.keymap.set("n", "<DOWN>", "<Plug>(accelerated_jk_gj)", { silent = true })
vim.keymap.set("n", "<UP>", "<Plug>(accelerated_jk_gk)", { silent = true})

-- /{pattern}の入力中は「/」をタイプすると自動で「\/」が入力されるようになる
vim.keymap.set("c", "/", function()
  return (vim.fn.getcmdtype() == "/") and "\\/" or "/"
end, { noremap = true, expr = true })
-- ?{pattern}の入力中は「?」をタイプすると自動で「\?」が入力されるようになる
vim.keymap.set("c", "?", function()
  return (vim.fn.getcmdtype() == "?") and "\\?" or "?"
end, { noremap = true, expr = true })

-- Fernのキーバインドを設定する
vim.keymap.set("n", "<space>fd", ":Fern . -drawer<CR>", { noremap = true, silent = true })

-- Telescopeの設定を行う
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")

telescope.setup {
  extensions = {
    project = {
      base_dirs = {
        { path = "~/dotfiles", max_depth = 1 },
        { path = "~/sanctum/org", max_depth = 1 },
        { path = "~/sanctum/projects", max_depth = 2 },
      },
      order_by = "asc",
      hidden_files = true,
    },
  },
}

function find_files() 
 local telescope_themes = require("telescope.themes") 
  telescope_builtin.find_files(telescope_themes.get_ivy())
end

function live_grep()
  local telescope_themes = require("telescope.themes")
  telescope_builtin.live_grep(telescope_themes.get_ivy())
end

vim.keymap.set("n", "<space>ff", telescope_builtin.find_files, { noremap= true, silent = true })
vim.keymap.set("n", "<space>pf", telescope_builtin.find_files, { noremap= true, silent = true })
vim.keymap.set("n", "<space>fs", live_grep, { noremap= true, silent = true })
vim.keymap.set("n", "<space>sp", live_grep, { noremap= true, silent = true })
vim.keymap.set("n", "<space>fb", telescope_builtin.buffers, { noremap= true, silent = true })
vim.keymap.set("n", "<space>fh", telescope_builtin.help_tags, { noremap= true, silent = true })
vim.keymap.set("n", "<space>pp", telescope.extensions.project.project, { noremap = true, silent = true })
vim.keymap.set("n", "<space>fr", telescope.extensions.recent_files.pick, { noremap = true, silent = true })

-- ターミナルで<Esc>か<C-[>を押した時にノーマルモードに戻る
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { noremap = true, silent = true })

-- ターミナルを開く
vim.keymap.set("n", "<space>ot", (function() vim.cmd("ToggleTerm") end), { noremap = true, silent = true })
vim.keymap.set("n", "<space>oT", (function() vim.cmd("term") end), { noremap= true, silent = true })
vim.keymap.set("n", "<space>gg", (function() vim.cmd("Neogit") end), { noremap= true, silent = true })

----------------------------------------------------------------------
-- LSP
----------------------------------------------------------------------
-- <https://github.com/neovim/nvim-lspconfig#suggested-configuration>より引用
--
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>F", function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
local lspconfig = require("lspconfig")
lspconfig["pyright"].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}
lspconfig["ruby_ls"].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}
lspconfig["tsserver"].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}
lspconfig["gopls"].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}
lspconfig["rust_analyzer"].setup{
  on_attach = on_attach,
  flags = lsp_flags,
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = {}
  }
}
lspconfig["hie"].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}
