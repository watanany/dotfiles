require("plugins")

-- プラグイン管理ファイルに書き込みが行われた場合、PackerCompileを行うようにする
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
-- ステータスラインを常に表示する
vim.o.laststatus = 2
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

-- fzfのコマンドのプレフィックスを設定(e.g. :Files -> :FzfFiles)
vim.g["fzf_command_prefix"] = "Fzf" -- `let g:fzf_command_prefix = "Fzf"`と同じ意味

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
vim.keymap.set("n", "<UP>", "<Plug>(accelerated_jk_gk)", { silent = true })

-- /{pattern}の入力中は「/」をタイプすると自動で「\/」が入力されるようになる
vim.keymap.set("c", "/", function()
  return (vim.fn.getcmdtype() == "/") and "\\/" or "/"
end, { noremap = true, expr = true })
-- ?{pattern}の入力中は「?」をタイプすると自動で「\?」が入力されるようになる
vim.keymap.set("c", "?", function()
  return (vim.fn.getcmdtype() == "?") and "\\?" or "?"
end, { noremap = true, expr = true })

-- ターミナルで<Esc>か<C-[>を押した時にノーマルモードに戻る
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { noremap = true, silent = true })

-- ターミナルを開く
vim.keymap.set("n", "<space>ot", (function() vim.cmd("ToggleTerm") end), { noremap = true, silent = true })
vim.keymap.set("n", "<space>oT", (function() vim.cmd("term") end), { noremap = true, silent = true })

-- :PackerSync
vim.keymap.set("n", "<space>hrr", (function() require("packer").sync() end), { noremap = true, silent = true })

-- 各種設定のトグル
vim.keymap.set("n", "Tl", (function() vim.wo.list = not vim.wo.list end), { noremap = true, silent = true })
vim.keymap.set("n", "Tn", (function() vim.wo.number = not vim.wo.number end), { noremap = true, silent = true })
vim.keymap.set("n", "Tw", (function() vim.wo.wrap = not vim.wo.wrap end), { noremap = true, silent = true })
vim.keymap.set("n", "Tp", (function() vim.o.paste = not vim.o.paste end), { noremap = true, silent = true })

-- タブ関連
vim.keymap.set("n", "<space><tab>n", ":tablast | tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space><tab>d", ":tabclose<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space><tab>[", ":tabprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space><tab>]", ":tabnext<CR>", { noremap = true, silent = true })

for i = 1, 9 do
  local key = string.format("<space><tab>%d", i)
  local cmd = string.format(":tabnext %d<CR>", i)
  vim.keymap.set("n", key, cmd, { noremap = true, silent = true })
end

-- neogit
vim.keymap.set("n", "<space>gg", require("neogit").open, { noremap = true, silent = true })

----------------------------------------------------------------------
-- Telescope
----------------------------------------------------------------------
-- Fernのキーバインドを設定する
vim.keymap.set("n", "<space>ft", ":Fern . -drawer<CR>", { noremap = true, silent = true })

-- Telescopeの設定を行う
local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local telescope_actions = require("telescope.actions")

telescope.setup {
  extensions = {
    project = {
      base_dirs = {
        { path = "~/dotfiles",         max_depth = 1 },
        { path = "~/sanctum/org",      max_depth = 1 },
        { path = "~/sanctum/projects", max_depth = 2 },
      },
      order_by = "asc",
      hidden_files = true,
    },
  },
  defaults = {
    mappings = {
      i = {
        -- 最初のESCでTelescopeを閉じる
        -- cf. <https://www.reddit.com/r/neovim/comments/pzxw8h/telescope_quit_on_first_single_esc/>
        ["<esc>"] = telescope_actions.close,
      },
    },
  },
}

local function find_files()
  telescope_builtin.find_files({ hidden = true })
end

local function live_grep()
  telescope_builtin.live_grep({ hidden = true })
end

local function find_neovim_configs()
  telescope_builtin.find_files({ cwd = "~/.config/nvim", hidden = true })
end

vim.keymap.set("n", "<space>ff", find_files, { noremap = true, silent = true })
vim.keymap.set("n", "<space>pf", find_files, { noremap = true, silent = true })
vim.keymap.set("n", "<space>fp", find_neovim_configs, { noremap = true, silent = true })
vim.keymap.set("n", "<space>fs", live_grep, { noremap = true, silent = true })
vim.keymap.set("n", "<space>sp", live_grep, { noremap = true, silent = true })
vim.keymap.set("n", "<space>fb", telescope_builtin.buffers, { noremap = true, silent = true })
vim.keymap.set("n", "<space>bB", telescope_builtin.buffers, { noremap = true, silent = true })
vim.keymap.set("n", "<space>fh", telescope_builtin.help_tags, { noremap = true, silent = true })
vim.keymap.set("n", "<space>pp", telescope.extensions.project.project, { noremap = true, silent = true })
vim.keymap.set("n", "<space>pP", telescope.extensions.projects.projects, { noremap = true, silent = true })
-- vim.keymap.set("n", "<space>fr", telescope.extensions.recent_files.pick, { noremap = true, silent = true })
vim.keymap.set("n", "<space>fr", ":Telescope frecency<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>fR", ":Telescope frecency workspace=CWD<CR>", { noremap = true, silent = true })

----------------------------------------------------------------------
-- LSP
----------------------------------------------------------------------
-- <https://github.com/neovim/nvim-lspconfig#suggested-configuration>より引用
--
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, buffer)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = buffer }
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

  require("lsp-format").on_attach(client, buffer, { sync = true })
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lspconfig = require("lspconfig")

lspconfig["lua_ls"].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}

lspconfig["pyright"].setup {
  on_attach = on_attach,
  flags = lsp_flags,
  -- settings = {
  --   python = {
  --     venvPath = ".",
  --     pythonPath = ".venv/bin/python",
  --     analysis = {
  --       extraPaths = { "." },
  --     },
  --   },
  -- },
}

lspconfig["ruby_ls"].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}

lspconfig["tsserver"].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}

lspconfig["gopls"].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}

lspconfig["rust_analyzer"].setup {
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

lspconfig["terraformls"].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}


----------------------------------------------------------------------
-- nvim-treesitter
----------------------------------------------------------------------
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query",
    "json", "yaml", "toml", "bash", "fish", "dockerfile",
    "hcl", "terraform",
    "python", "ruby", "go", "rust",
    "typescript", "javascript", "tsx", "html", "css", "tsx",
    "org",
  },
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },

  -- RRethy/nvim-treesitter-endwise
  endwise = {
    enable = true,
  },
}

----------------------------------------------------------------------
-- augroup / autocmd
----------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Yank時にハイライトを行う
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = "50",
    }
  end,
})

-- 保存時に行末の空白を削除する
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e",
})

-- ターミナルを開いた時にinsertモードを開始する
autocmd("TermOpen", {
  pattern = "",
  command = "startinsert",
})

-- ターミナルのバッファを離れた時にinsertモードを終了する
autocmd("BufLeave", {
  pattern = "term://*",
  command = "stopinsert",
})

----------------------------------------------------------------------
-- which-key
----------------------------------------------------------------------
local which_key = {
  ["<space>ot"] = "ターミナルをトグルする",
  ["<space>oT"] = "ターミナルを開く",

  ["<space>hrr"] = ":PackerSync",

  ["Tl"] = "不可視文字を表示をトグルする",
  ["Tn"] = "行番号の表示をトグルする",
  ["Tw"] = "折り返しをトグルする",
  ["Tp"] = "ペーストモードをトグルする",

  ["<space><tab>n"] = "タブを作成する",
  ["<space><tab>d"] = "タブを削除する",
  ["<space><tab>["] = "タブを一つ前に移動する",
  ["<space><tab>]"] = "タブを一つ後に移動する",

  ["<space>gg"] = "Neogitを開く",

  ["<space>ft"] = "ファイルツリーを開く",
  ["<space>pp"] = "プロジェクトを開く",
  ["<space>pf"] = "ファイル名で検索する",
  ["<space>ff"] = "ファイル名で検索する",
  ["<space>fp"] = "neovimの設定ファイルを検索する",
  ["<space>fr"] = "最近開いたファイルで検索する",
  ["<space>fR"] = "最近開いたファイルで検索する(カレントディレクトリ)",
  ["<space>fs"] = "ファイル内の文字列を検索する",
  ["<space>sp"] = "ファイル内の文字列を検索する",
  ["<space>fb"] = "バッファ一覧を表示する",
  ["<space>bB"] = "バッファ一覧を表示する",
  ["<space>fh"] = "ヘルプを表示する",

  ["[d"] = "一つ前の診断に戻る",
  ["]d"] = "一つ後の診断に進む",
  ["<space>q"] = "フローティングウィンドウにカーソルの下にあるシンボルに関する情報を表示します。2回呼び出すと、フローティング ウィンドウにジャンプします。",
  ["gD"] = "宣言にジャンプする",
  ["gd"] = "定義にジャンプする",
  ["K"] = "ホバーを表示する",
  ["gi"] = "実装にジャンプする",
  ["<C-k>"] = "シグネチャヘルプを表示する",
  ["<space>wa"] = "ワークスペースにフォルダを追加する",
  ["<space>wr"] = "ワークスペースからフォルダを削除する",
  ["<space>wl"] = "ワークスペースのフォルダを表示する",
  ["<space>D"] = "型定義にジャンプする",
  ["<space>rn"] = "変数名を変更する",
  ["<space>ca"] = "現在のカーソル位置で利用可能なコードアクションを選択する",
  ["gr"] = "リファレンス一覧を表示する",
  ["<space>F"] = "バッファ内のコードをフォーマットする",
}

for i = 1, 9 do
  local key = string.format("<space><tab>%d", i)
  local desc = string.format("タブ[%d]に移動する", i)
  which_key[key] = desc
end

require("which-key").register(which_key)
